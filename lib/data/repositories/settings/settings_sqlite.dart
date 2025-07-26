import 'package:existimer/core/constants/default_settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/snapshots/settings/settings_snapshot.dart';
import 'dart:convert';

class SettingsSqlite implements SnapshotRepository<SettingsSnapshot> {
  final Database db;
  static const String _table = 'settings';

  SettingsSqlite(this.db);

  @override
  Future<void> saveSnapshot(SettingsSnapshot snapshot) async {
    final map = snapshot.toMap();
    map['id'] = 1; // 强制 id = 1
    await db.insert(_table, {
      'id': 1,
      'json': jsonEncode(snapshot.toMap()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 实现接口要求，为了兼容SnapshotRepository
  @override
  Future<SettingsSnapshot?> loadSnapshot([String unused = ""]) async {
    final result = await db.query(_table, where: 'id = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      final jsonStr = result.first['json'] as String;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return SettingsSnapshot.fromMap(map);
    }

    // 查询失败返回默认值
    return DefaultSettings.toSnapshot();
  }
}
