// database_provider.dart
import 'package:riverpod/riverpod.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/application/services/database_init_service.dart';

// 数据库 Provider
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  // 确保在创建数据库之前已经初始化了数据库环境
  DatabaseInitService.initDatabaseEnvironment();
  
  final db = AppDatabase();
  await db.init(); // 初始化数据库
  return db;
});