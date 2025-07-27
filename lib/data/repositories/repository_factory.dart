import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/data/repositories/settings/settings_sqlite.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/data/repositories/task/task_sqlite.dart';
import 'package:existimer/data/repositories/task/task_mapping_sqlite.dart';
import 'package:existimer/data/repositories/task/task_meta_sqlite.dart';
import 'package:existimer/data/repositories/task/task_relation_sqlite.dart';
import 'package:existimer/data/repositories/history/history_sqlite.dart';
import 'package:sqflite/sqflite.dart';

/// Repository工厂类
/// 
/// 负责创建和管理各种数据访问对象
/// 减少AppStartupService的职责，提高代码的可维护性和可扩展性
class RepositoryFactory {
  /// 数据库实例
  final Database _database;

  /// 构造函数
  /// 
  /// [database] 数据库实例
  RepositoryFactory({required AppDatabase database}) : _database = database.db;

  /// 创建任务数据访问对象
  TaskSqlite createTaskRepository() {
    return TaskSqlite(_database);
  }

  /// 创建计时器单元数据访问对象
  TimerUnitSqlite createTimerUnitRepository() {
    return TimerUnitSqlite(_database);
  }

  /// 创建设置数据访问对象
  SettingsSqlite createSettingsRepository() {
    return SettingsSqlite(_database);
  }

  /// 创建任务映射数据访问对象
  TaskMappingSqlite createTaskMappingRepository() {
    return TaskMappingSqlite(_database);
  }
  
  /// 创建任务元数据访问对象
  TaskMetaSqlite createTaskMetaRepository() {
    return TaskMetaSqlite(_database);
  }
  
  /// 创建任务关系数据访问对象
  TaskRelationSqlite createTaskRelationRepository() {
    return TaskRelationSqlite(_database);
  }
  
  /// 创建历史记录数据访问对象
  HistorySqlite createHistoryRepository() {
    return HistorySqlite(_database);
  }
}