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

    //uuid与taskName映射表
    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_names (
        uuid TEXT PRIMARY KEY,
        name TEXT NOT NULL
      );
    ''');
  }
}