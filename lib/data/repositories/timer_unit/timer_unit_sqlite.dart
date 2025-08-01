import 'package:sqflite/sqflite.dart';

import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/data/snapshots/timer/timer_unit_snapshot.dart';
import 'package:existimer/common/constants/database_const.dart';

class TimerUnitSqlite extends SnapshotRepository<TimerUnitSnapshot> {
  final Database db;
  static final _table = DatabaseTables.timerUnits.name;

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
  Future<TimerUnitSnapshot?> queryByUuid(String uuid) async {
    final result = await db.query(
      _table,
      where: '${DatabaseTables.timerUnits.uuid.name} = ?',
      whereArgs: [uuid],
      limit: 1
    );

    if (result.isNotEmpty) {
      return TimerUnitSnapshot.fromMap(result.first);
    }

    return null;
  }
  
  /// 将扩展方法合并到主类内部
  /// 防止注入，虽然没啥用
  @override
  List<String> get validFields => [
    DatabaseTables.timerUnits.uuid.name,
    DatabaseTables.timerUnits.status.name,
    DatabaseTables.timerUnits.type.name,
    DatabaseTables.timerUnits.durationMs.name,
    DatabaseTables.timerUnits.referenceTime.name,
    DatabaseTables.timerUnits.lastRemainMs.name
  ];

  Future<List<TimerUnitSnapshot>> queryByField(
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

    return result.map((e) => TimerUnitSnapshot.fromMap(e)).toList();
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