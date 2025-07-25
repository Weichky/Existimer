import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:existimer/core/constants/database_version.dart';

class AppDatabase {
  static const String defaultDbName = 'app.db';

  late Database _db;
  bool _initialized = false;

  Future<void> init([String db = defaultDbName, bool reset = false]) async {
    if (_initialized) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, db);
    
    if (reset && await databaseExists(path)) {
      await deleteDatabase(path);
    }

    _db = await openDatabase(
      path,
      // 100 * major + minor, from 'database_version.dart'
      // from 100
      version: databaseVersion,
      onCreate: (db, version) async {
        await setupSchema(db);
        await db.insert('settings', {'id': 1, 'is_initialized': 1});
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
        reference_time INTEGER, -- 原先是TEXT
        last_remain_ms INTEGER  
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS history (
        history_uuid TEXT PRIMARY KEY,
        task_uuid TEXT NOT NULL,
        task_name TEXT,
        started_at INTEGER NOT NULL,  -- 原先是TEXT
      );
    ''');

    // Task和TaskMeta分离
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        uuid TEXT PRIMARY KEY,
        name TEXT,
        type TEXT NOT NULL,
        created_at INTEGER, -- 原先是TEXT
        last_used_at INTEGER, -- 原先是TEXT
        is_archived BOOLEAN DEFAULT 0,
        is_highlighted BOOLEAN DEFAULT 0,
        color TEXT,
        opacity REAL,
      );
    ''');  

    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_mapping (
        task_uuid TEXT NOT NULL,
        entity_uuid TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        PRIMARY KEY (task_uuid, entity_uuid)
      );
    ''');// PRIMARY KEY (task_id, entity_id) 组合主键

    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        is_initialized BOOLEAN NOT NULL,

        language TEXT,

        enable_dark_mode BOOLEAN,
        auto_dark_mode BOOLEAN,
        dark_mode_follow_system BOOLEAN,

        theme_color TEXT,

        enable_sound BOOLEAN,
        enable_finished_sound BOOLEAN,
        enable_notification BOOLEAN,

        enable_debug BOOLEAN,
        enable_log BOOLEAN,

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
        columns: ['is_initialized'],
        limit: 1
      );

      if (result.isEmpty) return false;

      final row = result.first;
      final initializedValue = row['is_initialized'] as int?;
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
      await _db.insert('settings', {'id': 1, 'is_initialized': 1});
    }
    else {
      await _db.update(
        'settings',
        {'is_initialized': 1},
        where: 'id = ?',
        whereArgs: [1]
      );
    }
  }

  Database get db => _db;
}
