import 'package:existimer/core/constants/default_settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

import 'package:existimer/core/constants/database_const.dart';

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
        await db.insert(DatabaseTables.settings.name, {
          DatabaseTables.settings.id.name: 1,
          DatabaseTables.settings.json.name: jsonEncode(DefaultSettings.toMap()),
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
    //     CREATE TABLE IF NOT EXISTS ${DatabaseTables.taskRelation.name} (
    //       ${DatabaseTables.taskRelation.fromUuid.name} TEXT NOT NULL,
    //       ${DatabaseTables.taskRelation.toUuid.name} TEXT NOT NULL,
    //       ${DatabaseTables.taskRelation.weight.name} REAL,
    //       ${DatabaseTables.taskRelation.isManuallyLinked.name} BOOLEAN NOT NULL DEFAULT 0,
    //       ${DatabaseTables.taskRelation.description.name} TEXT,
    //       PRIMARY KEY (${DatabaseTables.taskRelation.fromUuid.name}, ${DatabaseTables.taskRelation.toUuid.name})
    //     );
    //   ''');
    // }
  }

  Future<void> setupSchema([Database? dbOverride]) async {
    final db = dbOverride ?? _db;
    // 存储状态
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.timerUnits.name} (
        ${DatabaseTables.timerUnits.uuid.name} TEXT PRIMARY KEY,
        ${DatabaseTables.timerUnits.status.name} TEXT NOT NULL,
        ${DatabaseTables.timerUnits.type.name} TEXT NOT NULL,
        ${DatabaseTables.timerUnits.durationMs.name} INTEGER NOT NULL,
        ${DatabaseTables.timerUnits.referenceTime.name} INTEGER,
        ${DatabaseTables.timerUnits.lastRemainMs.name} INTEGER  
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.history.name} (
        ${DatabaseTables.history.historyUuid.name} TEXT PRIMARY KEY,
        ${DatabaseTables.history.taskUuid.name} TEXT NOT NULL,
        ${DatabaseTables.history.startedAt.name} INTEGER NOT NULL,
        ${DatabaseTables.history.sessionDurationMs.name} INTEGER,
        ${DatabaseTables.history.count.name} INTEGER,
        ${DatabaseTables.history.isArchived.name} BOOLEAN DEFAULT 0
      );
    ''');

    // Task和TaskMeta分离
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.tasks.name} (
        ${DatabaseTables.tasks.uuid.name} TEXT PRIMARY KEY,
        ${DatabaseTables.tasks.nameField.name} TEXT,
        ${DatabaseTables.tasks.type.name} TEXT NOT NULL,
        ${DatabaseTables.tasks.createdAt.name} INTEGER,
        ${DatabaseTables.tasks.lastUsedAt.name} INTEGER,
        ${DatabaseTables.tasks.isArchived.name} BOOLEAN DEFAULT 0,
        ${DatabaseTables.tasks.isHighlighted.name} BOOLEAN DEFAULT 0,
        ${DatabaseTables.tasks.color.name} TEXT,
        ${DatabaseTables.tasks.opacity.name} REAL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.taskMeta.name} (
        ${DatabaseTables.taskMeta.taskUuid.name} TEXT PRIMARY KEY,
        ${DatabaseTables.taskMeta.createdAt.name} INTEGER NOT NULL,
        ${DatabaseTables.taskMeta.firstUsedAt.name} INTEGER,
        ${DatabaseTables.taskMeta.lastUsedAt.name} INTEGER,
        ${DatabaseTables.taskMeta.totalUsedCount.name} INTEGER NOT NULL,
        ${DatabaseTables.taskMeta.totalCount.name} INTEGER,
        ${DatabaseTables.taskMeta.avgSessionDurationMs.name} INTEGER,
        ${DatabaseTables.taskMeta.icon.name} TEXT,
        ${DatabaseTables.taskMeta.baseColor.name} TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.taskMapping.name} (
        ${DatabaseTables.taskMapping.taskUuid.name} TEXT NOT NULL,
        ${DatabaseTables.taskMapping.entityUuid.name} TEXT NOT NULL,
        ${DatabaseTables.taskMapping.entityType.name} TEXT NOT NULL,
        PRIMARY KEY (${DatabaseTables.taskMapping.taskUuid.name}, ${DatabaseTables.taskMapping.entityUuid.name})
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.taskRelation.name} (
        ${DatabaseTables.taskRelation.fromUuid.name} TEXT NOT NULL,
        ${DatabaseTables.taskRelation.toUuid.name} TEXT NOT NULL,
        ${DatabaseTables.taskRelation.weight.name} REAL,
        ${DatabaseTables.taskRelation.isManuallyLinked.name} BOOLEAN NOT NULL DEFAULT 0,
        ${DatabaseTables.taskRelation.description.name} TEXT,
        PRIMARY KEY (${DatabaseTables.taskRelation.fromUuid.name}, ${DatabaseTables.taskRelation.toUuid.name})
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.settings.name} (
        ${DatabaseTables.settings.id.name} INTEGER PRIMARY KEY CHECK (${DatabaseTables.settings.id.name} = 1),
        ${DatabaseTables.settings.json.name} TEXT NOT NULL
      );
    ''');
  }

  Future<bool> checkInitialized() async {
    final result = await _db.query(DatabaseTables.settings.name, columns: [DatabaseTables.settings.json.name], limit: 1);

    return result.isNotEmpty;
  }

  Database get db => _db;
}