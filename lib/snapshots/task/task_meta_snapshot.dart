import 'package:existimer/snapshots/snapshot_base.dart';

class TaskMetaSnapshot extends SnapshotBase {
  final String taskUuid;

  final DateTime createdAt;
  final DateTime? firstUsedAt;
  final DateTime? lastUsedAt;

  final int totalUsedCount; // 作为任务完成的次数

  final int? totalCount; // 记次任务的总次数
  final Duration? avgSessionDuration;

  final String? icon;

  final String? baseColor;

  TaskMetaSnapshot({
    required this.taskUuid,
    required this.createdAt,
    this.firstUsedAt,
    this.lastUsedAt,
    required this.totalUsedCount,
    this.totalCount,
    this.avgSessionDuration,
    this.icon,
    this.baseColor,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'task_uuid': taskUuid,
      'create_at': createdAt.millisecondsSinceEpoch,
      'first_used_at': firstUsedAt?.millisecondsSinceEpoch,
      'last_used_at': lastUsedAt?.millisecondsSinceEpoch,
      'total_used_count': totalUsedCount,
      'total_count': totalCount,
      'avg_session_duration': avgSessionDuration?.inMilliseconds,
      'icon': icon,
      'base_color': baseColor,
    };
  }

  static TaskMetaSnapshot fromMap(Map<String, dynamic> map) {
    return TaskMetaSnapshot(
      taskUuid: map['task_uuid'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['create_at']),
      firstUsedAt:
          map['first_used_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['first_used_at'])
              : null,
      lastUsedAt:
          map['last_used_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['last_used_at'])
              : null,
      totalUsedCount: map['total_used_count'],
      totalCount: map['total_count'],
      avgSessionDuration:
          map['avg_session_duration'] != null
              ? Duration(milliseconds: map['avg_session_duration'])
              : null,
      icon: map['icon'],
      baseColor: map['base_color'],
    );
  }
}
