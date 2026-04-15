import 'package:existimer/application/controllers/timer/timer_controller.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:riverpod/riverpod.dart';

final timerProvider = AsyncNotifierProvider<TimerController, TimerUnit>(
  () => TimerController(),
);