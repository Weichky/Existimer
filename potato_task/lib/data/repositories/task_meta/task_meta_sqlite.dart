import 'package:sqflite/sqflite.dart';

import 'package:potato_task/data/repositories/snapshot_repository.dart';
import 'package:potato_task/snapshots/task_meta_snapshot.dart';


class TaskMetaSqlite implements SnapshotRepository<TaskMetaSnapshot>{
  final Database db;

  TaskMetaSqlite(this.db);

  @override
  Future<void> saveSnapshot(TaskMetaSnapshot snapshot) async {
    await db.insert(
      'task_meta',
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<TaskMetaSnapshot?> loadSnapshot(String uuid) async {
    final result = await db.query(
      'task_meta',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (result.isNotEmpty) {
      return TaskMetaSnapshot.fromMap(result.first);
    }

    return null;
  }
}