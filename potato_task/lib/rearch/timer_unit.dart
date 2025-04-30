import 'package:potato_task/core/constants/timer_unit_status.dart';

import 'package:potato_task/core/utils/helper.dart';

import 'package:potato_task/rearch/timer.dart';
import 'package:potato_task/core/constants/timer_unit_type.dart';


class TimerUnit {
  TimerUnitStatus _status;
  late TimerUnitType _timerUnitType;
  late TimerBase _currentTimer;
  String _uuid;

  TimerUnit._internal(this._currentTimer)
  : 
  _status = TimerUnitStatus.inactive,
  _timerUnitType = _currentTimer.isCountup ?
    TimerUnitType.countup :
    TimerUnitType.countdown,
  _uuid = UuidHelper.getUuid();

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
  Duration get duration => _currentTimer.duration();

  void toCountup() {
    if (!_status.isInactive) {
      _status = TimerUnitStatus.inactive;
    }
    _currentTimer
  }
}