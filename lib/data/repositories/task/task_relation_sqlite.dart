import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/task/task_relation_snapshot.dart';

class TaskRelationSqlite implements SnapshotRepository<TaskRelationSnapshot> {
  final Database db;
  static const String _table = 'task_relation';

  TaskRelationSqlite(this.db);

  @override
  Future<void> saveSnapshot(TaskRelationSnapshot snapshot) async {
    await db.insert(
      _table,
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<TaskRelationSnapshot?> loadSnapshot(String uuid) async {
    // TaskRelation使用fromUuid作为标识符进行查询
    final result = await db.query(
      _table,
      where: 'from_uuid = ?',
      whereArgs: [uuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return TaskRelationSnapshot.fromMap(result.first);
    }

    return null;
  }
  
  // 将扩展方法合并到主类内部
  static const validFields = [
    'from_uuid',
    'to_uuid',
    'weight',
    'is_manually_linked',
    'description',
  ];

  Future<List<TaskRelationSnapshot>> queryByField(
    String field,
    dynamic value
  ) async {
    if (!validFields.contains(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      where: '$field = ?',
      whereArgs: [value]
    );

    return result.map((e) => TaskRelationSnapshot.fromMap(e)).toList();
  }
  
  Future<List<TaskRelationSnapshot>> loadRelationsForTask(String taskUuid) async {
    final result = await db.query(
      _table,
      where: 'from_uuid = ? OR to_uuid = ?',
      whereArgs: [taskUuid, taskUuid]
    );

    return result.map((e) => TaskRelationSnapshot.fromMap(e)).toList();
  }
  
  Future<void> deleteRelation(String fromUuid, String toUuid) async {
    await db.delete(
      _table,
      where: 'from_uuid = ? AND to_uuid = ?',
      whereArgs: [fromUuid, toUuid]
    );
  }
  
  Future<void> deleteByField(
    String field,
    dynamic value
  ) async {
    if (!validFields.contains(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    await db.delete(
      _table,
      where: '$field = ?',
      whereArgs: [value]
    );
  }
}