import 'package:existimer/snapshots/snapshot_base.dart';

class TaskMetaSnapshot extends SnapshotBase {
  final String taskUuid;

  final DateTime createAt;
  final DateTime? firstUsedAt;
  final DateTime? lastUsedAt;

  final int totalUsedCount; // 作为任务完成的次数

  final int? totalCount; // 记次任务的总次数
  final Duration? avgSessionDuration;

  final String? icon;

  final String? baseColor;

  TaskMetaSnapshot({
    required this.taskUuid,
    required this.createAt,
    this.firstUsedAt,
    this.lastUsedAt,
    required this.totalUsedCount,
    this.totalCount,
    this.avgSessionDuration,
    this.icon,
    this.baseColor,
  }); 
}