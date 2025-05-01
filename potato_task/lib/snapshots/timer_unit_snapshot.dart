import 'package:potato_task/core/constants/timer_unit_status.dart';
import 'package:potato_task/core/constants/timer_unit_type.dart';

class TimerUnitSnapshot {
  final String uuid;
  final TimerUnitStatus status;
  final TimerUnitType type;
  final Duration duration;
  final DateTime? referenceTime;
  final Duration? lastRemainTime;

  TimerUnitSnapshot({
    required this.uuid,
    required this.status,
    required this.type,
    required this.duration,
    this.referenceTime,
    this.lastRemainTime,
  });
}