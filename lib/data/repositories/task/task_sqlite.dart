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
  /// [field] 字段名
  /// [newValue] 新值
  /// [queryField] 查询字段名
  /// [queryValue] 查询值
  ///
  /// 注意，将会修改所有满足查询条件的记录
  /// 最好确保使用uuid等唯一标识符进行查询
  Future<void> updateByField(
    String field,
    dynamic newValue,
    String queryField,
    dynamic queryValue,
  ) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    if (!isValidField(queryField)) {
      throw ArgumentError('Invalid query field name: $queryField');
    }

    await db.update(
      _table,
      {field: newValue},
      where: '$queryField = ?',
      whereArgs: [queryValue],
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
  Future<List<TaskSnapshot>> queryByField(String field, dynamic value) async {
    return queryBatchByField(
      field: field,
      value: value,
      relation: QueryRelation.equal,
    );
  }

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
  Future<int> howMany({
    required String field,
    required dynamic value,
    required QueryRelation relation,
  }) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_table WHERE $field ${relation.operator} ?',
      [value],
    );

    final count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }
}
