import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/data/snapshots/task/task_meta_snapshot.dart';
import 'package:existimer/common/constants/database_const.dart';

class TaskMetaSqlite implements SnapshotRepository<TaskMetaSnapshot> {
  final Database db;
  static final String _table = DatabaseTables.taskMeta.name;

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
      where: '${DatabaseTables.taskMeta.taskUuid.name} = ?',
      whereArgs: [taskUuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return TaskMetaSnapshot.fromMap(result.first);
    }

    return null;
  }
  
  // 将扩展方法合并到主类内部
  static final validFields = [
    DatabaseTables.taskMeta.taskUuid.name,
    DatabaseTables.taskMeta.createdAt.name,
    DatabaseTables.taskMeta.firstUsedAt.name,
    DatabaseTables.taskMeta.lastUsedAt.name,
    DatabaseTables.taskMeta.totalUsedCount.name,
    DatabaseTables.taskMeta.totalCount.name,
    DatabaseTables.taskMeta.avgSessionDurationMs.name,
    DatabaseTables.taskMeta.icon.name,
    DatabaseTables.taskMeta.baseColor.name
  ];

  Future<List<TaskMetaSnapshot>> queryByField(
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

    return result.map((e) => TaskMetaSnapshot.fromMap(e)).toList();
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