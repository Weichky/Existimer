import 'package:existimer/common/constants/timer_unit_status.dart';
import 'package:existimer/common/constants/timer_unit_type.dart';

import 'package:existimer/data/snapshots/snapshot_base.dart';
import 'package:existimer/common/constants/database_const.dart';

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
      DatabaseTables.timerUnits.uuid.name: uuid,
      DatabaseTables.timerUnits.status.name: status.name,
      DatabaseTables.timerUnits.type.name: type.name,
      DatabaseTables.timerUnits.durationMs.name: duration.inMilliseconds,
      DatabaseTables.timerUnits.referenceTime.name: referenceTime?.millisecondsSinceEpoch,
      DatabaseTables.timerUnits.lastRemainMs.name: lastRemainTime?.inMilliseconds,
    };
  }

  static TimerUnitSnapshot fromMap(Map<String, dynamic> map) {
    return TimerUnitSnapshot(
      uuid: map[DatabaseTables.timerUnits.uuid.name],
      status: TimerUnitStatus.fromString(map[DatabaseTables.timerUnits.status.name]),
      type: TimerUnitType.fromString(map[DatabaseTables.timerUnits.type.name]),
      duration: Duration(milliseconds: map[DatabaseTables.timerUnits.durationMs.name]),
      ///注意不能写成??形式
      ///因为在判断非空时必然调用Duration构造函数，而此函数只接受非空参数
      referenceTime:
        map[DatabaseTables.timerUnits.referenceTime.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(map[DatabaseTables.timerUnits.referenceTime.name])
          : null,
      lastRemainTime:
        map[DatabaseTables.timerUnits.lastRemainMs.name] != null
          ? Duration(milliseconds: map[DatabaseTables.timerUnits.lastRemainMs.name])
          : null,
    );
  }
}

// 不再使用
// 扩展方法无法访问类私有成员，不会破坏封装
// extension TimerUnitSnapshotStorage on TimerUnitSnapshot {
// }
