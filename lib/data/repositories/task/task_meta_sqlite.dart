import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/task/task_meta_snapshot.dart';

class TaskMetaSqlite implements SnapshotRepository<TaskMetaSnapshot> {
  final Database db;
  static const String _table = 'task_meta';

  TaskMetaSqlite(this.db);

  @override
  Future<void> saveSnapshot(TaskMetaSnapshot snapshot) async {
    await db.insert(
      _table,
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<TaskMetaSnapshot?> loadSnapshot(String taskUuid) async {
    final result = await db.query(
      _table,
      where: 'task_uuid = ?',
      whereArgs: [taskUuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return TaskMetaSnapshot.fromMap(result.first);
    }

    return null;
  }
}

extension TaskMetaSqliteQueries on TaskMetaSqlite {
  static const validFields = [
    'task_uuid',
    'created_at',
    'first_used_at',
    'last_used_at',
    'total_used_count',
    'total_count',
    'avg_session_duration',
    'icon',
    'base_color'
  ];

  Future<List<TaskMetaSnapshot>> queryByField(
    String field,
    dynamic value
  ) async {
    if (!validFields.contains(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      TaskMetaSqlite._table,
      where: '$field = ?',
      whereArgs: [value]
    );

    return result.map((e) => TaskMetaSnapshot.fromMap(e)).toList();
  }
}