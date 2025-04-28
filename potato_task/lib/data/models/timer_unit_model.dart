//timer_unit_model.dart
import 'package:flutter/foundation.dart';
import 'package:potato_task/domain/timer/timer_unit.dart';
import 'package:potato_task/core/constants/timer_type.dart';

class TimerUnitModel {
  final String uuid;
  final TimerType timerType;
  final int? countdownDurationSeconds;

  TimerUnitModel({
    required this.uuid,
    required this.timerType,
    this.countdownDurationSeconds,
  });

  factory TimerUnitModel.fromDb(Map<String, Object?> map) {
    return TimerUnitModel(
      uuid: map['uuid'] as String,
      timerType: TimerType.fromString(map['timer_type'] as String),
      countdownDurationSeconds: map['countdown_duration_seconds'] as int?,
    );
  }

  Map<String, Object?> toDb() {
    return {
      'uuid': uuid,
      'timer_type': _timerTypeToString(timerType),
      'countdown_duration_seconds': countdownDurationSeconds,
    };
  }

  factory TimerUnitModel.fromDomain(TimerUnit unit) {
    return TimerUnitModel(
      uuid: unit.uuid,
      timerType: unit.timerType,
      countdownDurationSeconds: unit.timerType.isCountdown ?
        unit.duration.inSeconds :
        null,
    );
  }

  TimerUnit toDomain() {
    final unit = timerType.isForward ?
      TimerUnit.forward() :
      TimerUnit.countdown(Duration(seconds: countdownDurationSeconds!));

    return unit;
  }

  String _timerTypeToString(TimerType timerType) {
    switch (timerType) {
      case TimerType.forward:
        return 'forward';
      case TimerType.countdown:
        return 'countdown';
    }
  }
}

