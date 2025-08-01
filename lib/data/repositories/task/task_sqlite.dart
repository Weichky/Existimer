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

  Future<List<TaskSnapshot>> queryByField(String field, dynamic value) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      where: '$field = ?',
      whereArgs: [value],
    );

    return result.map((e) => TaskSnapshot.fromMap(e)).toList();
  }

  Future<void> deleteByField(String field, dynamic value) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    await db.delete(_table, where: '$field = ?', whereArgs: [value]);
  }

  /// 批量查询
  ///
  /// [field] 查询字段
  /// [ascending] 升序,，默认为true；否则为降序
  /// [batchSize] 批量大小
  Future<List<TaskSnapshot>> queryBatchByFieldOrder({
    required String field,
    bool ascending = true,
    required int batchSize,
  }) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      orderBy: '$field ${ascending ? 'ASC' : 'DESC'}',
      limit: batchSize,
    );

    return result.map((e) => TaskSnapshot.fromMap(e)).toList();
  }

  /// 获取指定字段的最值
  ///
  /// [field] 字段名
  /// [ascending] 升序，默认为true；否则为降序
  Future<TaskSnapshot?> getByOrder({
    required String field,
    bool ascending = true,
  }) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      orderBy: '$field ${ascending ? 'ASC' : 'DESC'}',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return TaskSnapshot.fromMap(result.first);
    }

    return null;
  }

  Future<List<TaskSnapshot>> queryBatchByFieldOrderBefore({
    required String field,
    required dynamic value,
    bool ascending = true,
    required batchSize,
  }) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      where: '$field < ?',
      whereArgs: [value],
      orderBy: '$field ${ascending ? 'ASC' : 'DESC'}',
      limit: batchSize,
    );

    return result.map((e) => TaskSnapshot.fromMap(e)).toList();
  }

  Future<List<TaskSnapshot>> queryBatchByFieldOrderAfter({
    required String field,
    required dynamic value,
    bool ascending = true,
    required batchSize,
  }) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      where: '$field > ?',
      whereArgs: [value],
      orderBy: '$field ${ascending ? 'ASC' : 'DESC'}',
      limit: batchSize,
    );

    return result.map((e) => TaskSnapshot.fromMap(e)).toList();
  }

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
