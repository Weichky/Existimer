import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/timer/timer_unit_snapshot.dart';

class TimerUnitSqlite implements SnapshotRepository<TimerUnitSnapshot> {
  final Database db;
  static const _table = 'timer_units';

  TimerUnitSqlite(this.db);

  @override
  Future<void> saveSnapshot(TimerUnitSnapshot snapshot) async {
    await db.insert(
      _table,
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<TimerUnitSnapshot?> loadSnapshot(String uuid) async {
    final result = await db.query(
      _table,
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return TimerUnitSnapshot.fromMap(result.first);
    }

    return null;
  }
  
  // 将扩展方法合并到主类内部
  // 防止注入，虽然没啥用
  static const validFields = [
    'uuid',
    'status',
    'type',
    'duration_ms',
    'reference_time',
    'last_remain_ms'
  ];

  Future<List<TimerUnitSnapshot>> queryByField(
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

    return result.map((e) => TimerUnitSnapshot.fromMap(e)).toList();
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