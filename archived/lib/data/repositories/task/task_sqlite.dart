import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/data/snapshots/task/task_snapshot.dart';
import 'package:existimer/common/constants/database_const.dart';

class TaskSqlite extends SnapshotRepository<TaskSnapshot> {
  final Database db;
  static final String _table = DatabaseTables.tasks.name;

  TaskSqlite(this.db);

  @override
  Future<void> saveSnapshot(TaskSnapshot snapshot) async {
    await db.insert(
      _table,
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<TaskSnapshot?> queryByUuid(String uuid) async {
    final result = await db.query(
      _table,
      where: '${DatabaseTables.tasks.uuid.name} = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return TaskSnapshot.fromMap(result.first);
    }

    return null;
  }

  /// 将扩展方法合并到主类内部
  @override
  List<String> get validFields => [
    DatabaseTables.tasks.uuid.name,
    DatabaseTables.tasks.nameField.name,
    DatabaseTables.tasks.type.name,
    DatabaseTables.tasks.createdAt.name,
    DatabaseTables.tasks.lastUsedAt.name,
    DatabaseTables.tasks.isArchived.name,
    DatabaseTables.tasks.isHighlighted.name,
    DatabaseTables.tasks.color.name,
    DatabaseTables.tasks.opacity.name,
  ];

  Future<void> deleteByField(String field, dynamic value) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    await db.delete(_table, where: '$field = ?', whereArgs: [value]);
  }

  /// 更新指定字段
  ///
  /// [field] 要更新的字段名
  /// [newValue] 要设置的新值，可为null，将设置为null
  /// [queryField] 条件字段名
  /// [queryValue] 条件字段值；如果[relation]为QueryRelation.any，则忽略
  /// [relation] 查询关系（例如 =、<、>、LIKE 等）
  ///
  /// 注意：将会更新所有满足条件的记录，建议优先使用唯一标识（如uuid）
  /// 禁用QueryRelation.any关系
  Future<void> updateByField({
    required String field,
    dynamic newValue,
    required String queryField,
    required dynamic queryValue,
    required QueryRelation relation,
  }) async {
    if (relation == QueryRelation.any) {
      throw ArgumentError('QueryRelation.any is not allowed for updateByField');
    }

    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    if (!isValidField(queryField)) {
      throw ArgumentError('Invalid query field name: $queryField');
    }

    String where = '$queryField ${relation.operator} ?';
    List<dynamic> whereArgs = [queryValue];

    await db.update(
      _table,
      {field: newValue},
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// 批量查询系

  /// 批量查询基础方法
  ///
  /// 请优先使用其他方法，仔细阅读使用方法
  ///
  /// [field] 查询字段
  /// [value] 查询值，不是必须；如果relation为QueryRelation.any，则忽略此参数
  /// [ascending] 升序，默认为true；否则为降序
  /// [batchSize] 批量大小
  /// [relation] 查询关系，QueryRelation.any 表示任意关系
  ///
  /// 务必配套使用value和relation参数!!!
  Future<List<TaskSnapshot>> queryBatchByField({
    required String field,
    dynamic value,
    bool ascending = true,
    int? batchSize,
    required QueryRelation relation,
  }) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    String? where;
    List<dynamic>? whereArgs;

    if (relation != QueryRelation.any && value != null) {
      where = '$field ${relation.operator} ?';
      whereArgs = [value];
    }

    final result = await db.query(
      _table,
      where: where,
      whereArgs: whereArgs,
      orderBy: '$field ${ascending ? 'ASC' : 'DESC'}',
      limit: batchSize,
    );

    return result.map((e) => TaskSnapshot.fromMap(e)).toList();
  }

  /// 查询指定字段的所有匹配项
  ///
  /// [field] 字段名
  /// [value] 字段值
  Future<List<TaskSnapshot>> queryByField({
    required String field,
    required dynamic value,
  }) async {
    return queryBatchByField(
      field: field,
      value: value,
      relation: QueryRelation.equal,
    );
  }

  /// 封装自queryBatchByField方法
  ///
  /// 默认返回升序排列的结果
  Future<List<TaskSnapshot>> queryBatchByFieldBefore({
    required String field,
    required dynamic value,
    bool ascending = true,
    required batchSize,
  }) async {
    return queryBatchByField(
      field: field,
      value: value,
      ascending: ascending,
      batchSize: batchSize,
      relation: QueryRelation.lessThan,
    );
  }

  /// 封装自queryBatchByField方法
  ///
  /// 默认返回升序排列的结果
  Future<List<TaskSnapshot>> queryBatchByFieldAfter({
    required String field,
    required dynamic value,
    bool ascending = true,
    required batchSize,
  }) async {
    return queryBatchByField(
      field: field,
      value: value,
      ascending: ascending,
      batchSize: batchSize,
      relation: QueryRelation.greaterThan,
    );
  }

  /// 获取指定字段的最值
  ///
  /// [field] 字段名
  /// [ascending] 升序，默认为true；否则为降序
  Future<TaskSnapshot?> getExtremeByField({
    required String field,
    bool ascending = true,
  }) async {
    final resultList = await queryBatchByField(
      field: field,
      ascending: ascending,
      relation: QueryRelation.any,
    );

    return resultList.isNotEmpty ? resultList.first : null;
  }

  /// 获得满足指定字段和关系的记录数量
  ///
  /// [field] 字段名
  /// [value] 字段值
  /// [relation] 查询关系
  /// [andField] 可选的附加查询字段名，默认为null
  /// [andRelation] 可选的附加查询关系
  /// [andValue] 附加查询值
  Future<int> howMany({
    required String field,
    dynamic value,
    required QueryRelation relation,
    String? andField,
    QueryRelation? andRelation,
    dynamic andValue,
  }) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    if (andField != null && !isValidField(andField)) {
      throw ArgumentError('Invalid andField name: $andField');
    }

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (relation != QueryRelation.any && value != null) {
      whereClauses.add('$field ${relation.operator} ?');
      whereArgs.add(value);
    }

    if (andRelation != null &&
        andRelation != QueryRelation.any &&
        andValue != null &&
        andField != null) {
      whereClauses.add('$andField ${andRelation.operator} ?');
      whereArgs.add(andValue);
    }

    final where = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    final result = await db.query(
      _table,
      columns: ['COUNT(*) AS count'],
      where: where,
      whereArgs: whereArgs,
    );

    final count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  /// 重新排列所有orderIndex
  Future<void> reorderAll() async {
    final List<Map<String, Object?>> records = await db.query(
      _table,
      columns: ['rowid', DatabaseTables.tasks.orderIndex.name],
      orderBy: '${DatabaseTables.tasks.orderIndex.name} ASC',
    );

    final Batch batch = db.batch();

    for (int i = 0; i < records.length; i++) {
      final int rowid = records[i]['rowid'] as int;
      final int newOrderIndex = (i + 1) * orderIndexGap; // 从1开始计数

      batch.update(
        _table,
        {DatabaseTables.tasks.orderIndex.name: newOrderIndex},
        where: 'rowid = ?',
        whereArgs: [rowid],
      );
    }

    await batch.commit();
  }

  /// 局部重排orderIndex
  ///
  /// 排序对象包括边界
  /// [points] 需要调整的点数，包括边界
  Future<void> reorderAround({
    required int lowerBound,
    required int upperBound,
    required int points,
  }) async {
    final orderIndexColumn = DatabaseTables.tasks.orderIndex.name;

    final gap = (upperBound - lowerBound) ~/ (points - 1);

    // 获取位于 [lowerBound, upperBound] 之间的记录
    final List<Map<String, Object?>> records = await db.query(
      _table,
      columns: ['rowid', orderIndexColumn],
      where: '$orderIndexColumn >= ? AND $orderIndexColumn <= ?',
      whereArgs: [lowerBound, upperBound],
      orderBy: '$orderIndexColumn ASC',
    );

    final Batch batch = db.batch();

    for (
      int i = 0, newOrder = lowerBound;
      i < records.length;
      i++, newOrder += gap
    ) {
      final int rowid = records[i]['rowid'] as int;

      batch.update(
        _table,
        {orderIndexColumn: newOrder},
        where: 'rowid = ?',
        whereArgs: [rowid],
      );
    }

    await batch.commit(noResult: true);
  }
}