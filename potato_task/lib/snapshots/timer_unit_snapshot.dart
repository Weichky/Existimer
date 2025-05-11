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

  static TimerUnitSnapshot fromMap(Map<String, dynamic> map) {
    return TimerUnitSnapshot(
      uuid: map['uuid'],
      status: TimerUnitStatus.fromString(map['status']),
      type: TimerUnitType.fromString(map['type']),
      duration: Duration(milliseconds: map['duration_ms']),
      //注意不能写成??形式
      //因为在判断非空时必然调用Duration构造函数，而此函数只接受非空参数
      referenceTime:
        map['reference_time'] != null
          ? DateTime.parse(map['reference_time'])
          : null,
      lastRemainTime:
        map['last_remain_ms'] != null
          ? Duration(milliseconds: map['last_remain_ms'])
          : null,
    );
  }
}

extension TimerUnitSnapshotStorage on TimerUnitSnapshot {
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'status': status.name,
      'type': type.name,
      'duration_ms': duration.inMilliseconds,
      'reference_time': referenceTime?.toIso8601String(),
      'last_remain_ms': lastRemainTime?.inMilliseconds,
    };
  }
}
