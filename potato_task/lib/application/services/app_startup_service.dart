import 'package:potato_task/snapshots/task_meta_snapshot.dart';
import 'package:potato_task/snapshots/timerunit_snapshot.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:potato_task/data/repositories/snapshot_repository.dart';
import 'package:potato_task/data/repositories/app_database.dart';

class AppStartupService {
  final AppDatabase _database;
  final SnapshotRepository<TaskMetaSnapshot> _taskRepo;
  final SnapshotRepository<TimerUnitSnapshot> _timerRepo;

  AppStartupService({
    required AppDatabase database,
    required SnapshotRepository<TaskMetaSnapshot> taskRepo,
    required SnapshotRepository<TimerUnitSnapshot> timerRepo,
  }) :
    _database = database,
    _taskRepo = taskRepo,
    _timerRepo = timerRepo
  ;

  Future<void> initializedApp() async {
    await _database.init();

    final isInitialized = await _database.checkInitialized();
    if (!isInitialized) {
      // await _database.setupSchema(); //多余了
      await _database.setInitializedFlag();
    }

    await _recoverUnfinishedTimers();
    // await _cleanupIfNeeded();
  }

  Future<void> _recoverUnfinishedTimers() async {
    // 未完成逻辑
  }
}