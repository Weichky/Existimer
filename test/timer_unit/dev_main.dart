import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:existimer/application/services/app_startup_service.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/snapshots/timer_unit_snapshot.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';

import 'package:existimer/domain/timer/timer_unit.dart';

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

  final TimerUnit timerUnit = TimerUnit.countdown(Duration(seconds: 20));
  int counter = 0;

  final TimerUnitSqlite timerRepo = appStartupService.timerRepo;

  List<TimerUnitSnapshot> snapshots = await timerRepo.queryByField(
    'status',
    'active'
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
      print(timerUnit.duration);

      if (counter >= 6) {
        timer.cancel();
        print('now for $counter.\n');
        completer.complete();
      }
    }
  );

  await completer.future;

  // if (timerUnit.status.isActive || timerUnit.status.isTimeout) {
  //   timerUnit.pause();
  // }

  counter = 0;

  Timer.periodic(Duration(seconds: 1), (timer) {
    counter++;
    print(timerUnit.duration);

    if (counter >= 6) {
      timer.cancel();
      print('now for $counter.\n');
    }
  });

  _saveSnapshotAsync();
}
