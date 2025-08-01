import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/data/snapshots/task/task_mapping_snapshot.dart';
import 'package:existimer/common/constants/database_const.dart';

class TaskMappingSqlite extends SnapshotRepository<TaskMappingSnapshot> {
  final Database db;
  static final String _table = DatabaseTables.taskMapping.name;

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
  Future<TaskMappingSnapshot?> queryByUuid(String uuid) async {
    /// TaskMapping使用taskUuid作为标识符进行查询
    final result = await db.query(
      _table,
      where: '${DatabaseTables.taskMapping.taskUuid.name} = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return TaskMappingSnapshot.fromMap(result.first);
    }

    return null;
  }
  
  /// 将扩展方法合并到主类内部
  @override
  List<String> get validFields => [
    DatabaseTables.taskMapping.taskUuid.name,
    DatabaseTables.taskMapping.entityUuid.name,
    DatabaseTables.taskMapping.entityType.name,
  ];

  Future<List<TaskMappingSnapshot>> queryByField(
    String field,
    dynamic value,
  ) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      where: '$field = ?',
      whereArgs: [value],
    );

    return result.map((e) => TaskMappingSnapshot.fromMap(e)).toList();
  }

  Future<List<TaskMappingSnapshot>> loadMappingsForTask(String taskUuid) async {
    final result = await db.query(
      _table,
      where: '${DatabaseTables.taskMapping.taskUuid.name} = ?',
      whereArgs: [taskUuid],
    );

    return result.map((e) => TaskMappingSnapshot.fromMap(e)).toList();
  }

  Future<List<TaskMappingSnapshot>> loadMappingsForEntity(String entityUuid) async {
    final result = await db.query(
      _table,
      where: '${DatabaseTables.taskMapping.entityUuid.name} = ?',
      whereArgs: [entityUuid],
    );

    return result.map((e) => TaskMappingSnapshot.fromMap(e)).toList();
  }

  Future<void> deleteMapping(String taskUuid, String entityUuid) async {
    await db.delete(
      _table,
      where: '${DatabaseTables.taskMapping.taskUuid.name} = ? AND ${DatabaseTables.taskMapping.entityUuid.name} = ?',
      whereArgs: [taskUuid, entityUuid],
    );
  }
  
  Future<void> deleteByField(
    String field,
    dynamic value,
  ) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    await db.delete(
      _table,
      where: '$field = ?',
      whereArgs: [value],
    );
  }

  /// 检查传入的字段名是否在允许的字段列表中
  bool isValidField(String field) {
    return validFields.contains(field);
  }
}