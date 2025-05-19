import 'package:potato_task/core/constants/timer_unit_status.dart';
import 'package:potato_task/core/constants/timer_unit_type.dart';

import 'package:potato_task/core/utils/helper.dart';
import 'package:potato_task/core/utils/clock.dart';

import 'package:potato_task/domain/timer/timer.dart';

import 'package:potato_task/snapshots/timer_unit_snapshot.dart';

class TimerUnit {
  //TimerUnit状态
  String _uuid;
  TimerUnitStatus _status;
  late TimerUnitType _timerUnitType;
  late TimerBase _currentTimer;

  //TimerUnit计时数据
  Duration _duration;
  DateTime? _referenceTime;
  Duration? _lastRemainTime;
  Clock clock;

  TimerUnit._internal(this._timerUnitType, this._duration)
    : _uuid = UuidHelper.getUuid(),
    _status = TimerUnitStatus.inactive,
    _currentTimer =
    _timerUnitType.isCountup ? CountupTimer() : CountdownTimer(_duration),
    _referenceTime = null,
    _lastRemainTime = _timerUnitType.isCountdown ? _duration : null,
    clock = Clock();

  factory TimerUnit.countup() {
    return TimerUnit._internal(TimerUnitType.countup, Duration());
  }

  factory TimerUnit.countdown(Duration time) {
    return TimerUnit._internal(TimerUnitType.countdown, time);
  }

  //定义get方法
  String get uuid => _uuid;
  TimerUnitStatus get status => _status;
  TimerUnitType get type => _timerUnitType;

  void toCountup() {
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer = CountupTimer();
    _timerUnitType = TimerUnitType.countup;

    _duration = Duration();
    _referenceTime = null;
  }

  void toCountdown(Duration time) {
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer = CountdownTimer(time);
    _timerUnitType = TimerUnitType.countdown;

    _duration = time;
    _referenceTime = null;
    _lastRemainTime = time;
  }

  void start() {
    if (_status.isInactive) {
      _update();
      _currentTimer.start(clock.currentTime);
      _status = TimerUnitStatus.active;

    }
    else {
      throw StateError("TimerUnit must be inactive before you call start().");
    }
  }

  void pause() {

    _checkTimeout();

    if (_status.isActive) {
      _update();
      _currentTimer.stop(clock.currentTime);
      _reset(_duration);
      _status = TimerUnitStatus.paused;
    }
    else if (_status.isTimeout) {
      stop();
    }
    else {
      throw StateError("You must start TimerUnit before calling pause().");
    }
  }

  void resume() {
    if (_status.isPaused) {
      _update();
      _currentTimer.start(clock.currentTime);

      _status = TimerUnitStatus.active;
    }
    else {
      throw StateError("You must pause TimerUnit before calling resume().");
    }
  }

  void stop() {
    if (_status.isInactive) {
      return;
    }
    else {
      _update();
      _currentTimer.stop(clock.currentTime);

      _status = TimerUnitStatus.inactive;
    }
  }

  // 注意：务必在同时使用_update()和_currentTimer.stop()时
  // 先使用_update()再使用使用_currentTimer.stop()
  // 后续务必处理此处逻辑！
  void _update() {
    if (!_currentTimer.isWorking) {
      _currentTimer.start(_innerTime());
    } // 避免空endTime和startTime

    if (_timerUnitType.isCountup) {
      // 对于正计时是总时长
      _duration += _currentTimer.duration(clock.currentTime);
      _referenceTime = _currentTimer.referenceTime();
    }
    else {
      print('before _update' + _duration.toString());
      _duration = _currentTimer.duration(_innerTime());
      _referenceTime = _currentTimer.referenceTime();
      print('after _update' + _duration.toString());
    }
  }

  // 一定要看上面的_update()提示！
  void _checkTimeout() {
    if (!_currentTimer.isWorking) {
      _currentTimer.start(clock.currentTime);
    } // 避免空endTime和startTime

    if (_currentTimer.isCountdown) {
      if ((_currentTimer as CountdownTimer).duration(clock.currentTime) <=
        Duration()) {
        _status = TimerUnitStatus.timeout;
      }
    }
  }

  //注意不要填入负值
  void _reset([Duration? remainTime]) {
    assert(
    remainTime == null || remainTime > Duration(),
    "Should not reset from negtive remainTime."
    );
    if (_currentTimer is CountupTimer) {
      (_currentTimer as CountupTimer).reset();
    }
    else if (_currentTimer is CountdownTimer && remainTime != null) {
      (_currentTimer as CountdownTimer).reset(remainTime);
    }
    else {
      throw ArgumentError("Cannot reset without remainTime.");
    }
  }

  DateTime _innerTime() => _timerUnitType.isCountdown ? _referenceTime ?? clock.currentTime : clock.currentTime;

  TimerUnitSnapshot toSnapshot() => TimerUnitSnapshot(
    uuid: _uuid,
    status: _status,
    type: _timerUnitType,
    duration: _duration,
    referenceTime: _referenceTime,
    lastRemainTime: _lastRemainTime
  );

  void fromSnapshot(TimerUnitSnapshot timerUnitSnapshot) {
    _uuid = timerUnitSnapshot.uuid;
    _status = timerUnitSnapshot.status;
    _timerUnitType = timerUnitSnapshot.type;
    _duration = timerUnitSnapshot.duration;
    _referenceTime = timerUnitSnapshot.referenceTime;
    _lastRemainTime = timerUnitSnapshot.lastRemainTime;

    //需要检测恢复时的状态

    _currentTimer =
    _timerUnitType.isCountup ? CountupTimer() : CountdownTimer(_duration);
  }
}
