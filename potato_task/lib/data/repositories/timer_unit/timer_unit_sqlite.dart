import 'package:sqflite/sqflite.dart';

import 'package:potato_task/data/repositories/snapshot_repository.dart';
import 'package:potato_task/snapshots/timerunit_snapshot.dart';

class TimerUnitSqlite implements SnapshotRepository<TimerUnitSnapshot>{
  final Database db;

  TimerUnitSqlite(this.db);

  @override
  Future<void> saveSnapshot(TimerUnitSnapshot snapshot) async {
    await db.insert(
      'timer_units',
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<TimerUnitSnapshot?> loadSnapshot(String uuid) async {
    final result = await db.query(
      'timer_units',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (result.isNotEmpty) {
      return TimerUnitSnapshot.fromMap(result.first);
    }

    return null;
  }
}