import 'package:sqflite/sqflite.dart';

import 'package:potato_task/data/repositories/timer_unit_repository.dart';
import 'package:potato_task/snapshots/timer_unit_snapshot.dart';

class TimerUnitSqlite implements TimerUnitRepository{
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