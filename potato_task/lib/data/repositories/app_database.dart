import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  late Database _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await setupSchema(db);
        await db.insert('settings', {'key': 'initialized', 'value': '1'});
      },
    );
  }

  Future<void> setupSchema([Database? dbOverride]) async {
    final db = dbOverride ?? _db;
    //存储状态
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

    //将meta和数据分离
    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_meta (
        uuid TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        created_at TEXT,
        archived INTEGER DEFAULT 0,
        note TEXT
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
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      );
    ''');
  }


  Future<bool> checkInitialized() async {
    try {
      final result = await _db.query(
        'settings',
        where: 'key = ?',
        whereArgs: ['initialized'],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> setInitializedFlag() async {
    await _db.insert('settings', {'key': 'initialized', 'value': 1});
  }

  Database get db => _db;
}