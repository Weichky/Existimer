import 'package:potato_task/core/constants/timer_unit_status.dart';

import 'package:potato_task/core/utils/helper.dart';
import 'package:potato_task/core/services/clock.dart';

import 'package:potato_task/rearch/timer.dart';
import 'package:potato_task/core/constants/timer_unit_type.dart';

class TimerUnit {
  //TimerUnit状态
  final String _uuid;
  TimerUnitStatus _status;
  late TimerUnitType _timerUnitType;
  late TimerBase _currentTimer;

  //TimerUnit计时数据
  Duration _duration;
  late DateTime? _referenceTime;
  Clock clock;

  TimerUnit._internal(this._currentTimer)
    : _uuid = UuidHelper.getUuid(),
      _status = TimerUnitStatus.inactive,
      _timerUnitType =
          _currentTimer.isCountup
              ? TimerUnitType.countup
              : TimerUnitType.countdown,
      _duration = Duration(),
      clock = Clock();

  factory TimerUnit.countup() {
    return TimerUnit._internal(CountupTimer());
  }

  factory TimerUnit.countdown(Duration time) {
    return TimerUnit._internal(CountdownTimer(time));
  }

  //定义get方法
  String get uuid => _uuid;
  TimerUnitStatus get status => _status;
  TimerUnitType get type => _timerUnitType;

  void toCountup() {
    assert(_timerUnitType.isCountdown, "Only Countdown can call toCountup().");
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer = CountupTimer();
    _timerUnitType = TimerUnitType.countup;
  }

  void toCountdown() {
    assert(_timerUnitType.isCountup, "Only Countup can call toCountdown().");
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer = CountdownTimer(Duration(minutes: 35));
    _timerUnitType = TimerUnitType.countdown;
  }

  void start() {
    if (_status.isInactive) {
      _currentTimer.start(clock.currentTime);
      _status = TimerUnitStatus.active;

      _update();
    } else {
      throw StateError("TimerUnit must be inactive before you call start().");
    }
  }

  void pause() {
    _checkTimeout();

    if (_status.isActive) {
      _currentTimer.stop(clock.currentTime);
      _update();
      _reset(_duration);
      _status = TimerUnitStatus.paused;
    } else if (_status.isTimeout) {
      stop();
    } else {
      throw StateError("You must start TimerUnit before calling pause().");
    }
  }

  void resume() {
    if (_status.isPaused) {
      _currentTimer.start(clock.currentTime);
      _update();

      _status = TimerUnitStatus.active;
    } else {
      throw StateError("You must pause TimerUnit before calling resume().");
    }
  }

  void stop() {
    if (_status.isInactive) {
      return;
    } else {
      _currentTimer.stop(clock.currentTime);
      _update();
      _status = TimerUnitStatus.inactive;
    }
  }

  void _update() {
    if (_timerUnitType.isCountup) {
      _duration += _currentTimer.duration(clock.currentTime);
      _referenceTime = _currentTimer.referenceTime();
    } else {
      _duration = _currentTimer.duration(clock.currentTime);
      _referenceTime = _currentTimer.referenceTime();
    }
  }

  void _checkTimeout() {
    if (_currentTimer.isCountdown) {
      if ((_currentTimer as CountdownTimer).duration(clock.currentTime) <= Duration()) {
        _status = TimerUnitStatus.timeout;
      }
    }
  }

  //注意不要填入负值
  void _reset([Duration? remainTime]) {
    assert(remainTime == null || remainTime > Duration(), "Should not reset from negtive remainTime.");
    if (_currentTimer is CountupTimer) {
      (_currentTimer as CountupTimer).reset();
    } else if (_currentTimer is CountdownTimer && remainTime != null) {
      (_currentTimer as CountdownTimer).reset(remainTime);
    } else {
      throw ArgumentError("Cannot reset without remainTime.");
    }
  }


}