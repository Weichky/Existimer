import 'package:existimer/application/providers/settings/settings_provider.dart';
import 'package:existimer/common/constants/default_settings.dart';
import 'package:existimer/data/snapshots/task/task_snapshot.dart';
import 'package:existimer/domain/task/task.dart';
import 'package:existimer/application/controllers/collection_controller.dart';
import 'package:existimer/data/repositories/task/task_sqlite.dart';
import 'package:existimer/application/providers/task/task_repo_provider.dart';
import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/common/constants/database_const.dart';

class TaskController extends CollectionController<Task> {
  late TaskSqlite _repo;
  late Settings _settings;
  late int _batchSize;

  @override
  Future<List<Task>> build() async {
    _repo = await ref.read(taskRepoProvider.future);
    _settings = await ref.read(settingsProvider.future);
    _batchSize = _settings.taskBatchSize ?? DefaultSettings.taskBatchSize;
    return [];
  }

  Future<void> load() async {}

  @override
  Future<void> save() async {}
}

class OrderIndexAllocator {
  final TaskSqlite _repo;

  OrderIndexAllocator(this._repo);

  bool shouldReorder(int lower, int upper) => upper - lower <= gapThreshold;

  /// 在结尾分配一个新的order_index
  Future<int> allocateAtEnd() async {
    final TaskSnapshot? snapshot = await _repo.getExtremeByField(
      field: DatabaseTables.tasks.orderIndex.name,
      ascending: false,
    );

    final int index = snapshot == null ? 0 : snapshot.orderIndex + orderIndexGap;
    return index;
  }

  /// 在指定范围内分配一个新的order_index
  Future<int?> allocateBetween(int lower, int upper) async { 
    final gap = upper - lower;
    if (gap <= 1) {
      return null;
    } else {
      return lower + gap ~/ 2;
    }
  }

  Future<(int? lower,int? upper)?> getNeighborOrder({
    required String uuid
  }) async {
    int? lower;
    int? upper;

    final currentSnapshot = await _repo.queryByUuid(uuid);
    if (currentSnapshot == null) {
      return null;
    } else {
      final current = currentSnapshot.orderIndex;
      final beforeSnapshot = await _repo.queryBatchByFieldBefore(
        field: DatabaseTables.tasks.orderIndex.name,
        value: current,
        ascending: false,
        batchSize: 1);

      if (beforeSnapshot.isNotEmpty) {
        lower = beforeSnapshot.first.orderIndex;
      } else {
        lower = null;
      }

      final afterSnapshot = await _repo.queryBatchByFieldAfter(
        field: DatabaseTables.tasks.orderIndex.name,
        value: current,
        ascending: true,
        batchSize: 1);

      if (afterSnapshot.isNotEmpty) {
          upper = afterSnapshot.first.orderIndex;
        } else {
          upper = null;
      }
    }

    return (lower, upper);
  }

  Future<void> reorderAround({
    required String uuid,
    required int adjustRange,
    required int minGap,
  }) async { 
    final currentSnapshot = await _repo.queryByUuid(uuid);
    
  }
}
