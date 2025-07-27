import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/task/task_mapping_snapshot.dart';

class TaskMappingSqlite implements SnapshotRepository<TaskMappingSnapshot> {
  final Database db;
  static const String _table = 'task_mapping';

  TaskMappingSqlite(this.db);

  @override
  Future<void> saveSnapshot(TaskMappingSnapshot snapshot) async {
    await db.insert(
      _table,
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<TaskMappingSnapshot?> loadSnapshot(String uuid) async {
    // TaskMapping使用taskUuid作为标识符进行查询
    final result = await db.query(
      _table,
      where: 'task_uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return TaskMappingSnapshot.fromMap(result.first);
    }

    return null;
  }
}

extension TaskMappingSqliteQueries on TaskMappingSqlite {
  static const validFields = [
    'task_uuid',
    'entity_uuid',
    'entity_type',
  ];

  Future<List<TaskMappingSnapshot>> queryByField(
    String field,
    dynamic value,
  ) async {
    if (!validFields.contains(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      TaskMappingSqlite._table,
      where: '$field = ?',
      whereArgs: [value],
    );

    return result.map((e) => TaskMappingSnapshot.fromMap(e)).toList();
  }

  Future<List<TaskMappingSnapshot>> loadMappingsForTask(String taskUuid) async {
    final result = await db.query(
      TaskMappingSqlite._table,
      where: 'task_uuid = ?',
      whereArgs: [taskUuid],
    );

    return result.map((e) => TaskMappingSnapshot.fromMap(e)).toList();
  }

  Future<List<TaskMappingSnapshot>> loadMappingsForEntity(String entityUuid) async {
    final result = await db.query(
      TaskMappingSqlite._table,
      where: 'entity_uuid = ?',
      whereArgs: [entityUuid],
    );

    return result.map((e) => TaskMappingSnapshot.fromMap(e)).toList();
  }

  Future<void> deleteMapping(String taskUuid, String entityUuid) async {
    await db.delete(
      TaskMappingSqlite._table,
      where: 'task_uuid = ? AND entity_uuid = ?',
      whereArgs: [taskUuid, entityUuid],
    );
  }
  
  Future<void> deleteByField(
    String field,
    dynamic value,
  ) async {
    if (!validFields.contains(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    await db.delete(
      TaskMappingSqlite._table,
      where: '$field = ?',
      whereArgs: [value],
    );
  }
}