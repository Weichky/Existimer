// database_provider.dart
import 'package:riverpod/riverpod.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/application/services/database_init_service.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// 数据库 Provider
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  /// 初始化数据库环境
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  final db = AppDatabase();
  await db.init(); /// 初始化数据库
  return db;
});