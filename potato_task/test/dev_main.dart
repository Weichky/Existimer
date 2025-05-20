import 'package:flutter/widgets.dart';
import 'dart:io';
import 'dart:async';

import 'package:potato_task/application/services/app_startup_service.dart';
import 'package:potato_task/data/repositories/app_database.dart';
import 'package:potato_task/snapshots/timer_unit_snapshot.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:potato_task/data/repositories/timer_unit/timer_unit_sqlite.dart';

import 'package:potato_task/domain/timer/timer_unit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final AppDatabase appDatabase = AppDatabase();
  await appDatabase.init();

  final AppStartupService appStartupService = AppStartupService(
    database: appDatabase
  );

  await appStartupService.initializeApp();

  final TimerUnit timerUnit = TimerUnit.countup();
  int counter = 0;

  final TimerUnitSqlite timerRepo = appStartupService.timerRepo;

  List<TimerUnitSnapshot> snapshots = await timerRepo.queryByField(
    'status',
    'paused'
  );

  if (snapshots.isNotEmpty) {
    TimerUnitSnapshot snapshot = snapshots.first;

    timerUnit.fromSnapshot(snapshot);

    print(timerUnit.toSnapshot().toMap());
    // 现在可以使用 snapshot 了
  }
  else {
  }

  Future<void> _saveSnapshotAsync() async {
    await timerRepo.saveSnapshot(timerUnit.toSnapshot());
    print(timerUnit.toSnapshot().toMap());
  }

  if (timerUnit.status.isPaused) {
    timerUnit.resume();
    print(timerUnit.toSnapshot().toMap());
  }

  if (timerUnit.status.isInactive) {
    timerUnit.start();
  }

  final completer = Completer<void>();

  Timer.periodic(Duration(seconds: 1), (timer) {
      counter++;
      print('$counter seconds.\n');

      if (counter >= 6) {
        timer.cancel();
        print('now for $counter.\n');
        completer.complete();
      }
    }
  );

  await completer.future;

  if (timerUnit.status.isActive) {
    timerUnit.pause();
  }

  _saveSnapshotAsync();
}
