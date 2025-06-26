import 'package:existimer/core/constants/default_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/user_settings_snapshot.dart';

class UserSettingsSqlite implements SnapshotRepository<UserSettingsSnapshot> {
  final Database db;
  static const String _table = 'settings';

  UserSettingsSqlite(this.db);

  @override
  Future<void> saveSnapshot(UserSettingsSnapshot snapshot) async {
    final map = snapshot.toMap();
    map['id'] = 1; // 强制 id = 1
    await db.insert(_table, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 实现接口要求，为了兼容SnapshotRepository
  @override
  Future<UserSettingsSnapshot?> loadSnapshot([String unused = ""]) async {
    final result = await db.query(_table, where: 'id = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      return UserSettingsSnapshot.fromMap(result.first);
    }

    // 查询失败返回默认值
    return DefaultSettings.toSnapshot();
  }
}
