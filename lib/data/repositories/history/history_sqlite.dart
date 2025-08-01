import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/data/snapshots/history/history_snapshot.dart';
import 'package:existimer/common/constants/database_const.dart';

class HistorySqlite extends SnapshotRepository<HistorySnapshot> {
  final Database db;
  static final String _table = DatabaseTables.history.name;

  HistorySqlite(this.db);

  @override
  Future<void> saveSnapshot(HistorySnapshot snapshot) async {
    await db.insert(
      _table,
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<HistorySnapshot?> queryByUuid(String historyUuid) async {
    final result = await db.query(
      _table,
      where: '${DatabaseTables.history.historyUuid.name} = ?',
      whereArgs: [historyUuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return HistorySnapshot.fromMap(result.first);
    }

    return null;
  }
  
  /// 将扩展方法合并到主类内部
  @override
  List<String> get validFields => [
    DatabaseTables.history.historyUuid.name,
    DatabaseTables.history.taskUuid.name,
    DatabaseTables.history.startedAt.name,
    DatabaseTables.history.sessionDurationMs.name,
    DatabaseTables.history.count.name,
    DatabaseTables.history.isArchived.name,
  ];

  Future<List<HistorySnapshot>> queryByField(
    String field,
    dynamic value
  ) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      _table,
      where: '$field = ?',
      whereArgs: [value]
    );

    return result.map((e) => HistorySnapshot.fromMap(e)).toList();
  }
  
  Future<void> deleteByField(
    String field,
    dynamic value
  ) async {
    if (!isValidField(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    await db.delete(
      _table,
      where: '$field = ?',
      whereArgs: [value]
    );
  }
}