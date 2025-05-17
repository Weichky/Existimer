import 'package:potato_task/data/repositories/snapshot_repository.dart';

import 'package:potato_task/snapshots/user_settings_snapshot.dart';

import 'package:sqflite/sqflite.dart';


class UserSettingsSqlite implements SnapshotRepository<UserSettingsSnapshot> {
  final Database db;

  UserSettingsSqlite(this.db);

  @override
  Future<void> saveSnapshot(UserSettingsSnapshot snapshot) async {
    await db.insert(
      'task_meta',
      snapshot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<UserSettingsSnapshot?> loadSnapshot(String uuid) async {
    final result = await db.query(
      'task_meta',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (result.isNotEmpty) {
      return UserSettingsSnapshot.fromMap(result.first);
    }

    return null;
  }
}