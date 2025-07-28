import 'package:existimer/core/constants/timer_unit_status.dart';
import 'package:existimer/core/constants/timer_unit_type.dart';

import 'package:existimer/core/utils/helper.dart';
import 'package:existimer/core/utils/clock.dart';

import 'package:existimer/domain/timer/timer.dart';

import 'package:existimer/snapshots/timer/timer_unit_snapshot.dart';

// 注意_currentTimer.start()和_currentTimer.stop()分别更新了什么
// 需要对外提供时长接口
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

  /// 内部构造函数，用于创建倒计时或正计时器实例
  TimerUnit._internal(this._timerUnitType, this._duration)
    : _uuid = UuidHelper.getUuid(),
      _status = TimerUnitStatus.inactive,
      _currentTimer =
          _timerUnitType.isCountup ? CountupTimer() : CountdownTimer(_duration),
      _referenceTime = null,
      _lastRemainTime = _timerUnitType.isCountdown ? _duration : null;

  /// 工厂构造函数，用于创建正计时器实例
  factory TimerUnit.countup() {
    return TimerUnit._internal(TimerUnitType.countup, Duration());
  }

  /// 工厂构造函数，用于创建倒计时器实例
  factory TimerUnit.countdown(Duration time) {
    return TimerUnit._internal(TimerUnitType.countdown, time);
  }

  /// 根据快照数据恢复TimerUnit实例
  /// 复用patch逻辑
  factory TimerUnit.fromSnapshot(TimerUnitSnapshot snapshot) {
    final unit =
        snapshot.type.isCountup
            ? TimerUnit.countup()
            : TimerUnit.countdown(snapshot.duration);

    unit.fromSnapshot(snapshot);

    return unit;
  }

  /// 定义get方法
  String get uuid => _uuid;
  TimerUnitStatus get status => _status;
  TimerUnitType get type => _timerUnitType;

  /// 将计时器类型切换为正计时。
  void toCountup() {
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer = CountupTimer();
    _timerUnitType = TimerUnitType.countup;

    _duration = Duration();
    _referenceTime = null;
  }

  /// 将计时器类型切换为倒计时。
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

  /// 重置计时器到初始状态
  void reset([Duration? duration]) {
    // 先停止计时器（如果正在运行）
    if (!_status.isInactive) {
      stop();
    }

    // 重置为初始状态
    if (_timerUnitType.isCountup) {
      _reset();
      _duration = Duration();
    } else {
      final resetDuration = duration ?? _lastRemainTime ?? Duration.zero;
      _reset(resetDuration);
      _duration = resetDuration;
    }

    // 设置状态为未激活
    _status = TimerUnitStatus.inactive;
    _referenceTime = null;
  }

  /// 启动计时器
  void start() {
    if (_status.isInactive) {
      _currentTimer.start(Clock.instance.currentTime);
      _status = TimerUnitStatus.active;
      _referenceTime = _currentTimer.referenceTime();
    } else {
      throw StateError("TimerUnit must be inactive before you call start().");
    }
  }

  /// 暂停计时器
  void pause() {
    if (_status.isActive) {
      _currentTimer.stop(Clock.instance.currentTime);
      _update();
      _status = TimerUnitStatus.paused;
      _checkTimeout();
    }

    if (_status.isPaused) {
      // 空语句是应对上面的判断，有可能仍为paused，防止状态为paused时落入异常处理
    } else if (_status.isActive) {
      _reset(_duration);
    } else if (_status.isTimeout) {
      stop();
    } else {
      throw StateError("You must start TimerUnit before calling pause().");
    }
  }

  void resume() {
    /// 恢复计时器
    if (_status.isPaused) {
      if (_timerUnitType.isCountup) {
        (_currentTimer as CountupTimer).reset();
        _referenceTime = Clock.instance.currentTime;
      }
      _currentTimer.start(Clock.instance.currentTime);
      _status = TimerUnitStatus.active;
    } else {
      throw StateError("You must pause TimerUnit before calling resume().");
    }
  }

  void stop() {
    /// 停止计时器。
    if (_status.isInactive) {
      return;
    } else {
      _currentTimer.stop(Clock.instance.currentTime);
      _update();

      _status = TimerUnitStatus.inactive;
    }
  }

  // 注意：务必在同时使用_update()和_currentTimer.stop()时
  // 先使用_currentTimer.stop()
  void _update() {
    /// 更新计时器
    if (_timerUnitType.isCountup) {
      // 对于正计时是总时长
      _duration += _currentTimer.duration(Clock.instance.currentTime);
      _referenceTime = _currentTimer.referenceTime();
    } else {
      _duration = _currentTimer.duration(Clock.instance.currentTime);
      _referenceTime = _currentTimer.referenceTime();
    }
  }

  // 一定要看上面的_update()提示！
  void _checkTimeout() {
    /// 检查计时器是否超时
    if (_currentTimer.isCountdown) {
      if (_currentTimer.duration(Clock.instance.currentTime) <= Duration()) {
        _status = TimerUnitStatus.timeout;
      }
    }
  }

  //注意不要填入负值
  void _reset([Duration? remainTime]) {
    /// 重置计时器，如果计时器为倒计时，则需要传入剩余时间
    assert(
      remainTime == null || remainTime > Duration(),
      "Should not reset from negtive remainTime.",
    );
    if (_currentTimer is CountupTimer) {
      (_currentTimer as CountupTimer).reset();
    } else if (_currentTimer is CountdownTimer && remainTime != null) {
      (_currentTimer as CountdownTimer).reset(remainTime);
    } else {
      throw ArgumentError("Cannot reset without remainTime.");
    }
  }

  TimerUnitSnapshot toSnapshot() => TimerUnitSnapshot(
    uuid: _uuid,
    status: _status,
    type: _timerUnitType,
    duration: _duration,
    referenceTime: _referenceTime,
    lastRemainTime: _lastRemainTime,
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

    // 恢复计时器
    if (_timerUnitType.isCountup) {
      if (!_status.isInactive) {
        // 此时已有referenceTime
        (_currentTimer as CountupTimer).startTime = _referenceTime!;
        print(duration);
        print(_duration);
      }
    } else {
      if (!_status.isInactive) {
        (_currentTimer as CountdownTimer).remainDuration = _duration;
        // 此时已有referenceTime
        (_currentTimer as CountdownTimer).endTime = _referenceTime!;

        if (!_status.isPaused) {
          _currentTimer.stop(Clock.instance.currentTime);
        }

        _checkTimeout();
      }
    }
  }

  Duration get duration {
    if (_timerUnitType.isCountup) {
      if (_status.isPaused || _status.isInactive) {
        return _duration;
      } else if (_status.isActive) {
        // 此时还未更新
        return _duration +
            Clock.instance.currentTime.difference(
              _currentTimer.referenceTime(),
            );
      }
    } else {
      if (_status.isPaused || _status.isInactive) {
        return _duration;
      } else if (_status.isActive || _status.isTimeout) {
        return _currentTimer.referenceTime().difference(
          Clock.instance.currentTime,
        );
      }
    }

    throw StateError('Unexpected Error! This error should not appear.');
  }
}
