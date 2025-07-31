import 'package:existimer/common/constants/default_settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:existimer/data/repositories/snapshot_repository.dart';
import 'package:existimer/data/snapshots/settings/settings_snapshot.dart';
import 'dart:convert';
import 'package:existimer/common/constants/database_const.dart';

class SettingsSqlite implements SnapshotRepository<SettingsSnapshot> {
  final Database db;
  static final String _table = DatabaseTables.settings.name;

  SettingsSqlite(this.db);

  @override
  Future<void> saveSnapshot(SettingsSnapshot snapshot) async {
    final map = snapshot.toMap();
    await db.insert(_table, {
      DatabaseTables.settings.id.name: 1,
      DatabaseTables.settings.json.name: jsonEncode(snapshot.toMap()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// 实现接口要求，为了兼容SnapshotRepository
  @override
  Future<SettingsSnapshot?> loadSnapshot([String unused = ""]) async {
    final result = await db.query(_table, where: '${DatabaseTables.settings.id.name} = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      final jsonStr = result.first[DatabaseTables.settings.json.name] as String;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return SettingsSnapshot.fromMap(map);
    }

    /// 查询失败返回默认值
    return DefaultSettings.toSnapshot();
  }
}