import 'package:existimer/core/constants/default_settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

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
        await db.insert('settings', {
          'id': 1,
          'json': jsonEncode(DefaultSettings.toMap()),
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await upgradeSchema(db, oldVersion, newVersion);
      },
    );

    _initialized = true;
  }

  Future<void> upgradeSchema(
    Database db,
    int fromVersion,
    int toVersion,
  ) async {
    // 开发阶段留空

    // 例
    // if (fromVersion < 101 && toVersion >= 101) {
    //   await db.execute('''
    //     CREATE TABLE IF NOT EXISTS task_relation (
    //       from_uuid TEXT NOT NULL,
    //       to_uuid TEXT NOT NULL,
    //       weight REAL,
    //       is_manually_linked BOOLEAN NOT NULL DEFAULT 0,
    //       description TEXT,
    //       PRIMARY KEY (from_uuid, to_uuid)
    //     );
    //   ''');
    // }
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
        started_at INTEGER NOT NULL,  -- 原先是TEXT
        session_duration_ms INTEGER,
        count INTEGER,
        is_archived BOOLEAN DEFAULT 0,
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
      CREATE TABLE IF NOT EXISTS task_meta (
        task_uuid TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        first_used_at INTEGER,
        last_used_at INTEGER,
        total_used_count INTEGER NOT NULL,
        total_count INTEGER,
        avg_session_duration_ms INTEGER,
        icon TEXT,
        base_color TEXT,
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_mapping (
        task_uuid TEXT NOT NULL,
        entity_uuid TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        PRIMARY KEY (task_uuid, entity_uuid)
      );
    '''); // PRIMARY KEY (task_id, entity_id) 组合主键

    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_relation (
        from_uuid TEXT NOT NULL,
        to_uuid TEXT NOT NULL,
        weight REAL,
        is_manually_linked BOOLEAN NOT NULL DEFAULT 0,
        description TEXT,
        PRIMARY KEY (from_uuid, to_uuid)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        json TEXT NOT NULL,
      );
    ''');
  }

  Future<bool> checkInitialized() async {
    final result = await _db.query('settings', columns: ['json'], limit: 1);

    return result.isNotEmpty;
  }

  Database get db => _db;
}
