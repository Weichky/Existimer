import 'dart:math';
import 'package:path/path.dart';
import 'package:async/async.dart'; // 用于定时测量
import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


const String tableName = 'test_data';
const int orderIndexGap = 1000;

Future<Database> setupDb(int recordCount) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'test_times.db');

  // 删除旧数据库
  await deleteDatabase(path);

  final db = await openDatabase(path, version: 1,
      onCreate: (db, version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderIndex INTEGER,
        value INTEGER
      )
    ''');
  });

  // 批量插入 recordCount 条随机数据，包事务
  await db.transaction((txn) async {
    final batch = txn.batch();
    final rand = Random();
    for (int i = 0; i < recordCount; i++) {
      batch.insert(tableName, {
        'orderIndex': i * orderIndexGap,
        'value': rand.nextInt(1 << 31),
      });
    }
    await batch.commit(noResult: true);
  });

  return db;
}

Future<void> reorderAll(Database db) async {
  final records = await db.query(
    tableName,
    columns: ['id', 'orderIndex'],
    orderBy: 'orderIndex ASC',
  );

  final batch = db.batch();

  for (int i = 0; i < records.length; i++) {
    final id = records[i]['id'] as int;
    final newOrderIndex = (i + 1) * orderIndexGap;

    batch.update(
      tableName,
      {'orderIndex': newOrderIndex},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  await batch.commit(noResult: true);
}

Future<void> main() async {
  const testRecordCount = 1000; // 你可修改此值调节测试规模
  const testRepeat = 1000;

  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = await setupDb(testRecordCount);
  print('数据库初始化完成，记录数：$testRecordCount');

  double totalTime = 0;

  for (int i = 0; i < testRepeat; i++) {
    final stopwatch = Stopwatch()..start();
    await reorderAll(db);
    stopwatch.stop();

    final timeSec = stopwatch.elapsedMilliseconds / 1000.0;
    print('第${i + 1}次重排耗时: ${timeSec.toStringAsFixed(4)} 秒');
    totalTime += timeSec;
  }

  print('平均每次重排耗时: ${(totalTime / testRepeat).toStringAsFixed(4)} 秒');

  await db.close();
}
