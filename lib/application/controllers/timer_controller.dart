import 'dart:async';

import 'package:existimer/application/providers/settings_provider.dart';
import 'package:existimer/application/providers/timer_repo_provider.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/snapshots/timer_unit_snapshot.dart';
import 'package:existimer/snapshots/user_settings_snapshot.dart';
import 'package:riverpod/riverpod.dart';

//timer_controller.dart
class TimerController extends AsyncNotifier<TimerUnit> {
  late TimerUnitSqlite _repo;
  late UserSettingsSnapshot _settings;

  @override
  FutureOr<TimerUnit> build() async {
    _repo = await ref.read(timerRepoProvider.future);
    _settings = await ref.watch(settingsProvider.future);

    return _settings.defaultTimerUnitType!.isCountup
        ? TimerUnit.countup()
        : TimerUnit.countdown(_settings.countdownDuration!);
  }

  // 计时器读写
  Future<void> loadFromUuid(String uuid) async {
    final TimerUnitSnapshot? snapshot = await _repo.loadSnapshot(uuid);
    if (snapshot != null) {
      state = AsyncData(TimerUnit.fromSnapshot(snapshot));
    } else {
      state = AsyncError(StateError('Timer not found'), StackTrace.current);
    }
  }

  // 计时器控制
  Future<void> start() async {
    final unit = state.valueOrNull;
    if (unit == null) return;

    try {
      unit.start();
      state = AsyncData(unit); // 更新状态
    } catch (e, st) {
      // 捕获错误并将错误更新到 state
      state = AsyncError(e, st);
    }
  }

  Future<void> stop() async {
    final unit = state.valueOrNull;
    if (unit == null) return;

    try {
      unit.stop();
      state = AsyncData(unit);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> pause() async {
    final unit = state.valueOrNull;
    if (unit == null) return;

    try {
      unit.pause();
      state = AsyncData(unit);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> resume() async {
    final unit = state.valueOrNull;
    if (unit == null) return;

    try {
      unit.resume();
      state = AsyncData(unit);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
