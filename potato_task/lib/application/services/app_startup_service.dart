import 'package:potato_task/core/constants/default_config.dart';
import 'package:potato_task/snapshots/task_meta_snapshot.dart';

import 'package:potato_task/data/repositories/configs/user_settings_sqlite.dart';
import 'package:potato_task/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:potato_task/data/repositories/task_meta/task_meta_sqlite.dart';

import 'package:potato_task/data/repositories/snapshot_repository.dart';
import 'package:potato_task/data/repositories/app_database.dart';

class AppStartupService {
  final AppDatabase _database;
  final TaskMetaSqlite _taskRepo;
  final TimerUnitSqlite _timerRepo;
  final UserSettingsSqlite _settingsRepo;

  AppStartupService({
    required AppDatabase database,
  }) :
    _database = database,
    _taskRepo = TaskMetaSqlite(database.db),
    _timerRepo = TimerUnitSqlite(database.db),
    _settingsRepo = UserSettingsSqlite(database.db);

  Future<void> initializeApp() async {
    await _database.init();

    final isInitialized = await _database.checkInitialized();
    if (!isInitialized) {
      await _database.setInitializedFlag();
      await _settingsRepo.saveSnapshot(DefaultSettings.toSnapshot());
    }

    await _recoverUnfinishedTimers();
    // await _cleanupIfNeeded();
  }

  Future<void> _recoverUnfinishedTimers() async {
    // 未完成逻辑
  }

  get timerRepo => _timerRepo;
}
