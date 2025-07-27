import 'package:existimer/core/constants/default_settings.dart';
import 'package:existimer/data/repositories/repository_factory.dart';
import 'package:existimer/data/repositories/settings/settings_sqlite.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/data/repositories/task/task_sqlite.dart';
import 'package:existimer/data/repositories/task/task_mapping_sqlite.dart';
import 'package:existimer/data/repositories/task/task_meta_sqlite.dart';
import 'package:existimer/data/repositories/task/task_relation_sqlite.dart';
import 'package:existimer/data/repositories/history/history_sqlite.dart';
import 'package:existimer/data/repositories/app_database.dart';

/// 应用启动服务类
/// 
/// 负责初始化应用所需的各种服务
/// 管理数据库连接和通过RepositoryFactory创建各种数据访问对象
class AppStartupService {
  /// 应用数据库实例
  final AppDatabase _database;
  
  /// Repository工厂实例
  late final RepositoryFactory _repositoryFactory;
  
  /// 任务数据访问对象
  late final TaskSqlite _taskRepo;
  
  /// 计时器单元数据访问对象
  late final TimerUnitSqlite _timerRepo;
  
  /// 设置数据访问对象
  late final SettingsSqlite _settingsRepo;
  
  /// 任务映射数据访问对象
  late final TaskMappingSqlite _taskMappingRepo;
  
  /// 任务元数据访问对象
  late final TaskMetaSqlite _taskMetaRepo;
  
  /// 任务关系数据访问对象
  late final TaskRelationSqlite _taskRelationRepo;
  
  /// 历史记录数据访问对象
  late final HistorySqlite _historyRepo;

  /// 构造函数
  /// 
  /// [database] 应用数据库实例
  AppStartupService({
    required AppDatabase database
  }) : _database = database;

  /// 初始化应用
  /// 
  /// 初始化Repository工厂和各种数据访问对象
  /// 检查数据库是否已初始化，如果没有则插入默认设置
  /// 执行其他初始化任务
  Future<void> initializeApp() async {
    // 初始化Repository工厂
    _repositoryFactory = RepositoryFactory(database: _database);
    
    // 通过工厂创建各种数据访问对象
    _taskRepo = _repositoryFactory.createTaskRepository();
    _timerRepo = _repositoryFactory.createTimerUnitRepository();
    _settingsRepo = _repositoryFactory.createSettingsRepository();
    _taskMappingRepo = _repositoryFactory.createTaskMappingRepository();
    _taskMetaRepo = _repositoryFactory.createTaskMetaRepository();
    _taskRelationRepo = _repositoryFactory.createTaskRelationRepository();
    _historyRepo = _repositoryFactory.createHistoryRepository();

    // 数据库初始化在databaseProvider中完成
    final isInitialized = await _database.checkInitialized();
    if (!isInitialized) {
      await _settingsRepo.saveSnapshot(DefaultSettings.toSnapshot());
    }

    await _recoverUnfinishedTimers();
    // await _cleanupIfNeeded();
  }

  /// 恢复未完成的计时器
  /// 
  /// 用于在应用启动时恢复之前未完成的计时任务
  Future<void> _recoverUnfinishedTimers() async {
    // TODO: 实现未完成计时器的恢复逻辑
  }

  /// 获取计时器数据访问对象
  TimerUnitSqlite get timerRepo => _timerRepo;
  
  /// 获取设置数据访问对象
  SettingsSqlite get settingsRepo => _settingsRepo;
  
  /// 获取任务数据访问对象
  TaskSqlite get taskRepo => _taskRepo;
  
  /// 获取任务映射数据访问对象
  TaskMappingSqlite get taskMappingRepo => _taskMappingRepo;
  
  /// 获取任务元数据访问对象
  TaskMetaSqlite get taskMetaRepo => _taskMetaRepo;
  
  /// 获取任务关系数据访问对象
  TaskRelationSqlite get taskRelationRepo => _taskRelationRepo;
  
  /// 获取历史记录数据访问对象
  HistorySqlite get historyRepo => _historyRepo;
}