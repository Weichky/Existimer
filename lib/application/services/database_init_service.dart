import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/application/services/app_startup_service.dart';

/// 数据库初始化服务
/// 
/// 该服务负责在应用启动时正确初始化数据库
/// 特别是在桌面环境下需要使用 sqflite ffi
class DatabaseInitService {
  /// 初始化数据库环境
  /// 
  /// 在桌面环境下需要调用此方法来初始化 sqflite ffi
  static void initDatabaseEnvironment() {
    WidgetsFlutterBinding.ensureInitialized();
    
    // 初始化 sqflite ffi，针对桌面环境
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  /// 初始化应用数据库
  /// 
  /// [dbName] 数据库名称
  /// [reset] 是否重置数据库（仅用于测试）
  /// 返回初始化完成的 [AppStartupService] 实例
  static Future<AppStartupService> initializeAppDatabase({String dbName = 'app.db', bool reset = false}) async {
    // 初始化数据库环境
    initDatabaseEnvironment();
    
    // 创建并初始化应用数据库
    final appDatabase = AppDatabase();
    await appDatabase.init(dbName, reset);

    // 创建并初始化应用启动服务
    final appStartupService = AppStartupService(database: appDatabase);
    await appStartupService.initializeApp();

    return appStartupService;
  }
}