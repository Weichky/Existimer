import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:existimer/core/constants/database_version.dart';

class AppDatabase {
  static const String defaultDbName = 'app.db';

  late Database _db;
  bool _initialized = false;

  Future<void> init([String db = defaultDbName]) async {
    if (_initialized) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, db);
    
    _db = await openDatabase(
      path,
      // 100 * major + minor, from 'database_version.dart'
      // from 100
      version: databaseVersion,
      onCreate: (db, version) async {
        await setupSchema(db);
        await db.insert('settings', {'id': 1, 'initialized': 1});
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await upgradeSchema(db, oldVersion, newVersion);
      }
    );

    _initialized = true;
  }

  Future<void> upgradeSchema(Database db, int fromVersion, int toVersion) async {
    // 开发阶段留空

    // 例
    if (fromVersion < 101 && toVersion >= 101) {
      // await db.execute('''
        // CREATE TABLE IF NOT EXISTS new_table (
          // id TEXT PRIMARY KEY,
          // name TEXT NOT NULL
        // )
      // ''');
    }
  }

  Future<void> setupSchema([Database? dbOverride]) async {
    final db = dbOverride ?? _db;
    // 存储状态
    await db.execute('''
      CREATE TABLE IF NOT EXISTS timer_units (
        uuid TEXT PRIMARY KEY,
        status TEXT NOT NULL,
        type TEXT NOT NULL,
        duration_ms INTEGER NOT NULL,
        reference_time TEXT,
        last_remain_ms INTEGER
      );
    ''');

    // 将meta和数据分离
    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_meta (
        uuid TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        created_at TEXT,
        archived INTEGER DEFAULT 0,
        description TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS history (
        id TEXT PRIMARY KEY,
        uuid TEXT NOT NULL,
        start_time TEXT NOT NULL,
        note TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        initialized INTEGER NOT NULL,

        language TEXT,

        enable_dark_mode INTEGER,
        auto_dark_mode INTEGER,
        dark_mode_follow_system INTEGER,

        theme_color TEXT,

        enable_sound INTEGER,
        enable_finished_sound INTEGER,
        enable_notification INTEGER,

        enable_debug INTEGER,
        enable_log INTEGER,

        default_task_type TEXT,
        default_timer_unit_type TEXT,

        countdown_duration_ms INTEGER
      );
    ''');
  }

  Future<bool> checkInitialized() async {
    try {
      final result = await _db.query(
        'settings',
        columns: ['initialized'],
        limit: 1
      );

      if (result.isEmpty) return false;

      final row = result.first;
      final initializedValue = row['initialized'] as int?;
      return initializedValue == 1;
    }
    catch (e) {
      return false;
    }
  }

  Future<void> setInitializedFlag() async {
    final countResult = await _db.rawQuery('SELECT COUNT(*) FROM settings');
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    if (count == 0) {
      // 没有记录，插入一条，id 必须是 1
      await _db.insert('settings', {'id': 1, 'initialized': 1});
    }
    else {
      await _db.update(
        'settings',
        {'initialized': 1},
        where: 'id = ?',
        whereArgs: [1]
      );
    }
  }

  Database get db => _db;
}
