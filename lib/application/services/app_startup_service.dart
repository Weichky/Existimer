import 'package:existimer/core/constants/default_settings.dart';

import 'package:existimer/data/repositories/configs/user_settings_sqlite.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/data/repositories/task_meta/task_sqlite.dart';

import 'package:existimer/data/repositories/app_database.dart';

class AppStartupService {
  final AppDatabase _database;
  final TaskMetaSqlite _taskRepo;
  final TimerUnitSqlite _timerRepo;
  final UserSettingsSqlite _settingsRepo;

  AppStartupService({
    required AppDatabase database
  }) :
    _database = database,
    _taskRepo = TaskMetaSqlite(database.db),
    _timerRepo = TimerUnitSqlite(database.db),
    _settingsRepo = UserSettingsSqlite(database.db);

  Future<void> initializeApp() async {
    // 数据库初始化在databaseProvider中

    final isInitialized = await _database.checkInitialized();
    if (!isInitialized) {
      await _settingsRepo.saveSnapshot(DefaultSettings.toSnapshot());
    }

    await _recoverUnfinishedTimers();
    // await _cleanupIfNeeded();
  }

  Future<void> _recoverUnfinishedTimers() async {
    // 未完成逻辑
  }

  get timerRepo => _timerRepo;
  get settingsRepo => _settingsRepo;
}
