import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:existimer/application/services/app_startup_service.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/snapshots/timer/timer_unit_snapshot.dart';
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
    database: appDatabase,
  );

  await appStartupService.initializeApp();

  // final TimerUnit timerUnit = TimerUnit.countdown(Duration(seconds: 20));
  final TimerUnit timerUnit = TimerUnit.countup();
  int counter = 0;

  final TimerUnitSqlite timerRepo = appStartupService.timerRepo;

  List<TimerUnitSnapshot> snapshots = await timerRepo.queryByField(
    'status',
    'paused',
  );

  if (snapshots.isNotEmpty) {
    TimerUnitSnapshot snapshot = snapshots.first;

    timerUnit.fromSnapshot(snapshot);
  } else {}

  Future<void> printDatabaseState(int i) async {
    final snapshots = await timerRepo.queryByField('uuid', timerUnit.uuid);
    if (snapshots.isNotEmpty) {
      final loadedTimer = TimerUnit.fromSnapshot(snapshots.first);
      print(
        '【stage$i】数据库状态 - 数据库时间: ${loadedTimer.duration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(loadedTimer.duration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms',
      );
      print('数据结构快照: ${timerUnit.toSnapshot().toMap()}');
      print('数据库快照: ${loadedTimer.toSnapshot().toMap()}');
    } else {
      print('没有找到对应的快照数据。');
    }
  }

  Future<void> _saveSnapshotAsync(int i) async {
    await printDatabaseState(i);

    await timerRepo.saveSnapshot(timerUnit.toSnapshot());

    await printDatabaseState(i);
  }

    int stage = 0;

  if (timerUnit.status.isPaused) {
    timerUnit.resume();
    print(timerUnit.toSnapshot().toMap());
    await _saveSnapshotAsync(stage);
  }

  if (timerUnit.status.isInactive) {
    timerUnit.start();
    await _saveSnapshotAsync(stage);
  }

  final completer1 = Completer<void>();

  stage++;

  Timer.periodic(Duration(seconds: 1), (timer) {
    counter++;
    print(timerUnit.duration);

    if (counter >= 6) {
      timer.cancel();
      print('now for $counter.\n');
      completer1.complete();
    }
  });

  await completer1.future;

  if (timerUnit.status.isActive || timerUnit.status.isTimeout) {
    timerUnit.pause();
    await _saveSnapshotAsync(stage);
  }

  final completer2 = Completer<void>();

  stage++;

  Timer.periodic(Duration(seconds: 1), (timer) {
    counter++;
    print(timerUnit.duration);

    if (counter >= 12) {
      timer.cancel();
      print('now for $counter.\n');
      completer2.complete();
    }
  });

  await completer2.future;

  if (timerUnit.status.isPaused) {
    timerUnit.resume();
    await _saveSnapshotAsync(stage);
  }

  stage++;

  final completer3 = Completer<void>();

  Timer.periodic(Duration(seconds: 1), (timer) {
    counter++;
    print(timerUnit.duration);

    if (counter >= 18) {
      timer.cancel();
      print('now for $counter.\n');
      completer3.complete();
    }
  });

  await completer3.future;

  if (timerUnit.status.isActive || timerUnit.status.isTimeout) {
    timerUnit.pause();
    await _saveSnapshotAsync(stage); 
  }

  await _saveSnapshotAsync(stage);
}
