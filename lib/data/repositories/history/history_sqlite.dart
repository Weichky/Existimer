import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/history/history_snapshot.dart';

class HistorySqlite implements SnapshotRepository<HistorySnapshot> {
  final Database db;
  static const String _table = 'history';

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
  Future<HistorySnapshot?> loadSnapshot(String historyUuid) async {
    final result = await db.query(
      _table,
      where: 'history_uuid = ?',
      whereArgs: [historyUuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return HistorySnapshot.fromMap(result.first);
    }

    return null;
  }
}

extension HistorySqliteQueries on HistorySqlite {
  static const validFields = [
    'history_uuid',
    'task_uuid',
    'started_at',
    'session_duration_ms',
    'count',
    'is_archived',
  ];

  Future<List<HistorySnapshot>> queryByField(
    String field,
    dynamic value
  ) async {
    if (!validFields.contains(field)) {
      throw ArgumentError('Invalid field name: $field');
    }

    final result = await db.query(
      HistorySqlite._table,
      where: '$field = ?',
      whereArgs: [value]
    );

    return result.map((e) => HistorySnapshot.fromMap(e)).toList();
  }
}