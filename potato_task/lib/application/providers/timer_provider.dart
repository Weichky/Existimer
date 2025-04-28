//timer_provider.dart
import 'package:flutter/material.dart';
import 'package:potato_task/domain/timer/timer_unit.dart';

class TimerProvider extends ChangeNotifier {
  TimerUnit _timerUnit;

  TimerProvider(this._timerUnit);

  void start() {
    _timerUnit.start();
    notifyListeners();
  }

  void pause() {
    _timerUnit.pause();
    notifyListeners();
  }

  void resume() {
    _timerUnit.resume();
    notifyListeners();
  }

  void stop() {
    _timerUnit.stop();
    notifyListeners();
  }

  void toggle() {
    if (_timerUnit.timerType.isForward) {
      _timerUnit.toCountdown(/*此处暂且搁置*/Duration());
    } else {
      _timerUnit.toForward();
    }
  }
}