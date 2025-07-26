import 'package:existimer/core/constants/timer_unit_status.dart';
import 'package:existimer/core/constants/timer_unit_type.dart';

import 'package:existimer/snapshots/snapshot_base.dart';

class TimerUnitSnapshot extends SnapshotBase {
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'status': status.name,
      'type': type.name,
      'duration_ms': duration.inMilliseconds,
      'reference_time': referenceTime?.millisecondsSinceEpoch,
      'last_remain_ms': lastRemainTime?.inMilliseconds,
    };
  }

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
          ? DateTime.fromMillisecondsSinceEpoch(map['reference_time'])
          : null,
      lastRemainTime:
        map['last_remain_ms'] != null
          ? Duration(milliseconds: map['last_remain_ms'])
          : null,
    );
  }
}

// 不再使用
// 扩展方法无法访问类私有成员，不会破坏封装
// extension TimerUnitSnapshotStorage on TimerUnitSnapshot {
// }
