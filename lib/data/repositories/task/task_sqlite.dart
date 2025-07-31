import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/data/snapshots/task/task_snapshot.dart';
import 'package:existimer/common/constants/database_const.dart';

class TaskSqlite implements SnapshotRepository<TaskSnapshot> {
  final Database db;
  static final String _table = DatabaseTables.tasks.name;

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
      where: '${DatabaseTables.tasks.uuid.name} = ?',
      whereArgs: [uuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return TaskSnapshot.fromMap(result.first);
    }

    return null;
  }
  
  /// 将扩展方法合并到主类内部
  static final validFields = [
    DatabaseTables.tasks.uuid.name,
    DatabaseTables.tasks.nameField.name,
    DatabaseTables.tasks.type.name,
    DatabaseTables.tasks.createdAt.name,
    DatabaseTables.tasks.lastUsedAt.name,
    DatabaseTables.tasks.isArchived.name,
    DatabaseTables.tasks.isHighlighted.name,
    DatabaseTables.tasks.color.name,
    DatabaseTables.tasks.opacity.name
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