import 'package:existimer/application/providers/settings/settings_provider.dart';
import 'package:existimer/common/constants/default_settings.dart';
import 'package:existimer/data/snapshots/task/task_snapshot.dart';
import 'package:existimer/domain/task/task.dart';
import 'package:existimer/application/controllers/collection_controller.dart';
import 'package:existimer/data/repositories/task/task_sqlite.dart';
import 'package:existimer/application/providers/task/task_repo_provider.dart';
import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/common/constants/database_const.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// 任务控制器，负责管理任务集合的相关操作
class TaskController extends CollectionController<Task> {
  late TaskSqlite _repo;
  late Settings _settings;
  late int _batchSize;
  late OrderIndexAllocator _orderIndexAllocator;

  @override
  Future<List<Task>> build() async {
    _repo = await ref.read(taskRepoProvider.future);
    _settings = await ref.read(settingsProvider.future);
    _batchSize = _settings.taskBatchSize ?? DefaultSettings.taskBatchSize;
    _orderIndexAllocator = OrderIndexAllocator(_repo);
    return [];
  }

  Future<void> load() async {}

  @override
  Future<void> save() async {}
  
  @override
  Future<void> addItem(Task item) {
    // TODO: implement addItem
    throw UnimplementedError();
  }
  
  @override
  Future<void> removeWhere(bool Function(Task item) predicate) {
    // TODO: implement removeWhere
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateWhere(bool Function(Task item) predicate, Task Function(Task item) updater) {
    // TODO: implement updateWhere
    throw UnimplementedError();
  }
}

/// 用于管理任务排序索引的分配器
/// 实现了动态排序算法，避免频繁的全表重排
class OrderIndexAllocator {
  final TaskSqlite _repo;

  OrderIndexAllocator(this._repo);

  /// 判断是否需要重新排序的阈值条件
  /// 当两个相邻任务的orderIndex差值小于等于gapThreshold时需要重排
  /// gapThreshold在database_const.dart中定义，默认值为1
  bool shouldReorder(int lower, int upper) => upper - lower <= gapThreshold;

  /// 在任务列表末尾分配一个新的order_index
  /// 通过查询当前最大的orderIndex值，然后加上orderIndexGap作为新值
  /// orderIndexGap在database_const.dart中定义，默认值为2^53
  Future<int> allocateOrderAtEnd() async {
    // 获取orderIndex字段的最大值记录
    final TaskSnapshot? snapshot = await _repo.getExtremeByField(
      field: DatabaseTables.tasks.orderIndex.name,
      ascending: false,
    );

    // 如果没有记录，则从0开始；否则在最大值基础上加上orderIndexGap
    final int index =
        snapshot == null ? 0 : snapshot.orderIndex + orderIndexGap;
    return index;
  }

  /// 在指定的两个索引之间分配一个新的order_index
  /// 用于在两个相邻任务之间插入新任务
  /// 如果间隙太小（小于等于1）则返回null，表示需要重新排序
  Future<int?> allocateOrderBetween(int lower, int upper) async {
    final gap = upper - lower;
    if (gap <= 1) {
      // 间隙太小，无法插入新值
      return null;
    } else {
      // 返回中间值作为新任务的orderIndex
      return lower + gap ~/ 2;
    }
  }

  /// 在指定任务周围重新排序，用于解决索引冲突问题
  /// 这是一个递归算法，当局部区域过于密集时会逐步扩大范围重新分配索引
  /// 
  /// [uuid] 当前任务的唯一标识符
  /// [adjustRange] 调整范围，初始值通常为orderIndexAdjustRange（默认2^12）
  /// [minGap] 最小间隔，初始值通常为orderIndexAdjustMinGap（默认2^10）
  Future<void> reorderAround({
    required String uuid,
    required int adjustRange,
    required int minGap,
  }) async {
    // 获取当前任务快照
    final currentSnapshot = await _repo.queryByUuid(uuid);

    // 如果找不到当前任务，则直接返回
    if (currentSnapshot == null) {
      return;
    }

    // 计算调整范围的上下界
    // 下界不能小于0
    final currentOrderIndex = currentSnapshot.orderIndex;
    final lowerOrder =
        currentOrderIndex - adjustRange > 0
            ? currentOrderIndex - adjustRange
            : 0;
    // 上界为当前索引加上调整范围
    final upperOrder = currentOrderIndex + adjustRange;

    // 并行查询上下界附近的任务快照
    // 查询orderIndex小于lowerOrder的最大记录（最接近lowerOrder的记录）
    final lowerSnapshotFuture = _repo.queryBatchByFieldBefore(
      field: DatabaseTables.tasks.orderIndex.name,
      value: lowerOrder,
      ascending: false,
      batchSize: 1,
    );

    // 查询orderIndex大于upperOrder的最小记录（最接近upperOrder的记录）
    final upperSnapshotFuture = _repo.queryBatchByFieldAfter(
      field: DatabaseTables.tasks.orderIndex.name,
      value: upperOrder,
      ascending: true,
      batchSize: 1,
    );

    // 等待查询结果
    final lowerSnapshot = await lowerSnapshotFuture;
    final upperSnapshot = await upperSnapshotFuture;

    // 如果上下界都没有找到记录，则无需重排
    if (lowerSnapshot.isEmpty && upperSnapshot.isEmpty) {
      return;
    }

    // 获取上下界记录的UUID，如果不存在则为null
    final lowerUuid =
        lowerSnapshot.isNotEmpty ? lowerSnapshot.first.uuid : null;
    final upperUuid =
        upperSnapshot.isNotEmpty ? upperSnapshot.first.uuid : null;

    // 获取上下界记录的orderIndex，如果不存在则使用默认值
    // 下界记录的orderIndex，如果不存在则为0
    final lowerOrderInRange =
        lowerSnapshot.isNotEmpty ? lowerSnapshot.first.orderIndex : 0;
    // 上界记录的orderIndex，如果不存在则为当前记录的orderIndex
    final upperOrderInRange =
        upperSnapshot.isNotEmpty
            ? upperSnapshot.first.orderIndex
            : currentOrderIndex;

    // 统计在[lowerOrderInRange, upperOrderInRange]范围内的记录数量
    final howManyOrders = await _repo.howMany(
      field: DatabaseTables.tasks.orderIndex.name,
      relation: QueryRelation.greaterEqual,
      value: lowerOrderInRange,
      andField: DatabaseTables.tasks.orderIndex.name,
      andRelation: QueryRelation.lessEqual,
      andValue: upperOrderInRange,
    );

    // 判断是否需要全表重排
    // 计算平均间隙，如果平均间隙小于等于minGap，则需要全表重排
    final shouldReorderAll =
        (upperOrderInRange - lowerOrderInRange) ~/ howManyOrders <= minGap;

    if (shouldReorderAll) {
      // 执行全表重排，将所有记录的orderIndex重新按固定间隔分配
      // 间隔为orderIndexGap（默认1000）
      await _repo.reorderAll();
    } else {
      // 不需要全表重排，进行局部重排
      
      // 获取下界记录的前一个记录的orderIndex（即下界记录的"左邻居"）
      final lowerInRangeLowerNeighborOrder =
          lowerUuid == null ? 0 : await getLowerNeighborOrderByUuid(lowerUuid);
      
      // 获取上界记录的后一个记录的orderIndex（即上界记录的"右邻居"）
      final upperInRangeUpperNeighborOrder =
          upperUuid == null
              ? currentOrderIndex
              : await getUpperNeighborOrderByUuid(upperUuid);

      // 计算下界记录与其左邻居的间隙
      final lowerNeighborGap =
          (lowerInRangeLowerNeighborOrder ?? 0) - lowerOrderInRange;
      
      // 计算上界记录与其右邻居的间隙
      final upperNeighborGap =
          (upperInRangeUpperNeighborOrder ??
              currentOrderIndex) - upperOrderInRange;

      // 如果任一边界的邻居间隙小于等于最小间隙要求
      if (lowerNeighborGap <= minGap || upperNeighborGap <= minGap) {
        /// 判断是否还有近邻（间隙不为0）
        if (lowerNeighborGap != 0 || upperNeighborGap != 0) {
          // 递归调用，扩大调整范围继续尝试
          reorderAround(
            uuid: uuid,
            adjustRange: adjustRange + minGap,
            /// 拓展搜索范围
            minGap: minGap,
          );
        } else {
          // 没有更多邻居可以调整，直接返回
          return;
        }
      } else {
        // 局部区域有足够的空间进行重排
        // 调用_repo的reorderAround方法进行局部重排
        // 在[lowerInRangeLowerNeighborOrder, upperInRangeUpperNeighborOrder]范围内
        // 将howManyOrders+2个点（包括两个边界）重新均匀分配orderIndex
        _repo.reorderAround(
          lowerBound: lowerInRangeLowerNeighborOrder!,
          upperBound: upperInRangeUpperNeighborOrder!,
          points: howManyOrders + 2, // 包括边界
        );
      }
    }
  }

  /// 获取指定UUID任务的前一个任务的order_index
  /// 即查找orderIndex小于当前任务orderIndex的最大记录
  Future<int?> getLowerNeighborOrderByUuid(String uuid) async {
    // 获取当前任务
    final current = await _repo.queryByUuid(uuid);
    if (current == null) return null;

    // 查询orderIndex小于当前任务orderIndex的最大记录（即前一个任务）
    final before = await _repo.queryBatchByFieldBefore(
      field: DatabaseTables.tasks.orderIndex.name,
      value: current.orderIndex,
      ascending: false, // 降序排列，取第一个即为最接近的较小值
      batchSize: 1,
    );

    // 返回前一个任务的orderIndex，如果不存在则返回null
    return before.isNotEmpty ? before.first.orderIndex : null;
  }

  /// 获取指定UUID任务的后一个任务的order_index
  /// 即查找orderIndex大于当前任务orderIndex的最小记录
  Future<int?> getUpperNeighborOrderByUuid(String uuid) async {
    // 获取当前任务
    final current = await _repo.queryByUuid(uuid);
    if (current == null) return null;

    // 查询orderIndex大于当前任务orderIndex的最小记录（即后一个任务）
    final after = await _repo.queryBatchByFieldAfter(
      field: DatabaseTables.tasks.orderIndex.name,
      value: current.orderIndex,
      ascending: true, // 升序排列，取第一个即为最接近的较大值
      batchSize: 1,
    );

    // 返回后一个任务的orderIndex，如果不存在则返回null
    return after.isNotEmpty ? after.first.orderIndex : null;
  }

  /// 封装获取指定UUID任务前后邻居order_index的方法
  /// 同时获取前一个和后一个任务的orderIndex，提高效率
  Future<(int? lower, int? upper)?> getNeighborOrderByUuid(String uuid) async {
    // 获取当前任务
    final current = await _repo.queryByUuid(uuid);
    if (current == null) return null;

    // 并行获取前一个和后一个任务的orderIndex
    final results = await Future.wait([
      getLowerNeighborOrderByUuid(uuid),
      getUpperNeighborOrderByUuid(uuid),
    ]);

    // 返回元组形式的结果
    return (results[0], results[1]);
  }
}