import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:potato_task/data/repositories/snapshot_repository.dart';
import 'package:potato_task/data/repositories/app_database.dart';

class AppStartupService {
  final AppDatabase _database;
  final SnapshotRepository _snapshotRepository;

  AppStartupService(this._database, this._snapshotRepository);

  Future<void> initializedApp() async {
    await _database.init();

    final isInitialized = await _database.checkInitialized();
    if (!isInitialized) {
      await _database.setupSchema();
      await _database.setInitializedFlag();
    }

    await _recoverUnfinishedTimers();
    // await _cleanupIfNeeded();
  }

  Future<void> _recoverUnfinishedTimers() async {
    // 未完成逻辑
  }
}