import 'package:sqflite/sqflite.dart';

import 'package:potato_task/data/repositories/snapshot_repository.dart';
import 'package:potato_task/snapshots/task_meta_snapshot.dart';

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
  Future<TaskMetaSnapshot?> loadSnapshot(String uuid) async {
    final result = await db.query(
      _table,
      where: 'uuid = ?',
      whereArgs: [uuid],
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
    'uuid',
    'name',
    'type',
    'created_at',
    'archived',
    'description'
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
