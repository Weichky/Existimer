import 'dart:async';

import 'package:existimer/application/providers/database_provider.dart';
import 'package:existimer/application/providers/settings_provider.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/snapshots/timer_unit_snapshot.dart';
import 'package:riverpod/riverpod.dart';

//timer_controller.dart
class TimerController extends AsyncNotifier<TimerUnit> {
  late final TimerUnitSqlite repo;

  @override
  FutureOr<TimerUnit> build() async {
    final db = await ref.watch(databaseProvider.future);
    repo = TimerUnitSqlite(db.db);

    final settings = await ref.watch(settingsProvider.future);
    return settings.defaultTimerUnitType!.isCountup ?
      TimerUnit.countup() :
      TimerUnit.countdown(settings.countdownDuration!);
  }

  Future<void> loadFromUuid(String uuid) async {
    final TimerUnitSnapshot? snapshot = await repo.loadSnapshot(uuid);
    if (snapshot != null) {
      state = AsyncData(TimerUnit.fromSnapshot)
    }
  }
}