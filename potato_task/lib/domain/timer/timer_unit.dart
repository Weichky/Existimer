//timer_unit.dart
import 'package:potato_task/core/constants/timer_type.dart';
import 'package:potato_task/core/constants/timer_unit_status.dart';
import 'package:potato_task/domain/timer/timer.dart';

class TimerUnit {
  TimerUnitStatus _status;
  late TimerBase _currentTimer;

  //接入数据库
  // final TimerRepository timerRepository;

  TimerUnit._internal(this._currentTimer)
  : _status = TimerUnitStatus.inactive;

  factory TimerUnit.forward() {
    return TimerUnit._internal(ForwardTimer());
  }

  factory TimerUnit.countdown(Duration time) {
    return TimerUnit._internal(CountdownTimer(time));
  }

  //定义get方法
  String get timerUuid => _currentTimer.uuid;
  TimerUnitStatus get status => _status;
  TimerType get timerType => _currentTimer.timerType;

  //定义重置方法
  void toForward() {
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer = ForwardTimer();
  }

  void toCountdown(Duration time) {
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer = CountdownTimer(time);
  }

  void start() {
    if (_status.isInactive) {
        _currentTimer.start();
        _status = TimerUnitStatus.active;
    } else {
      throw StateError("Timer Unit must be inactive before started.");
    }
  }

  void pause() {
    //暂停前检查是否timeout
    _checkTimeout();

    if (_status.isActive) {
      _currentTimer.pause();
      _status = TimerUnitStatus.paused;

    } else {
      throw StateError("Timer Unit must be actived before paused.");
    }
  }

  void resume() {
    if (_status.isPaused) {
      _currentTimer.start();
      _status = TimerUnitStatus.active;
    } else {
      throw StateError("Timer Unit must be resumed from paused.");
    }
  }

  void stop() {
    //停止前检查是否timeout
    _checkTimeout();

    if (_status.isInactive) {
      return;
    }

    _currentTimer.stop();
    _status = TimerUnitStatus.inactive;

  }

  //检查倒计时是否超时
  void _checkTimeout() {
      if (_currentTimer.timerType.isCountdown) {
        CountdownTimer countdown = _currentTimer as CountdownTimer;
        if (countdown.remainTime <= Duration()) {
          _status = TimerUnitStatus.timeout;
        }
      }
  }
}