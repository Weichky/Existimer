import 'dart:async';

import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:riverpod/riverpod.dart';

//timer_controller.dart
class TimerController {
  final Ref _ref;
  TimerUnit _unit;
  Timer? _ticker;

  TimerController({required Ref ref, required TimerUnit unit})
    : _ref = ref,
      _unit = unit;

  TimerUnit get unit => _unit;

  void start() {

  }

  void _startTicker() {
    _ticker?.cancel();
  }
}