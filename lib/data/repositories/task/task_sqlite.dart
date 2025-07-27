import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/task/task_snapshot.dart';

class TaskSqlite implements SnapshotRepository<TaskSnapshot> {
  final Database db;
  static const String _table = 'tasks';

  TaskSqlite(this.db);

  @override
  Future<void> saveSnapshot(TaskSnapshot snapshot) async {
    await db.insert(
      _table,
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<TaskSnapshot?> loadSnapshot(String uuid) async {
    final result = await db.query(
      _table,
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return TaskSnapshot.fromMap(result.first);
    }

    return null;
  }
  
  // 将扩展方法合并到主类内部
  static const validFields = [
    'uuid',
    'name',
    'type',
    'created_at',
    'last_used_at',
    'is_archived',
    'is_highlighted',
    'color',
    'opacity'
  ];

  Future<List<TaskSnapshot>> queryByField(
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

    return result.map((e) => TaskSnapshot.fromMap(e)).toList();
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