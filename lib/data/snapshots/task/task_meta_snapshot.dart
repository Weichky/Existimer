import 'package:existimer/data/snapshots/snapshot_base.dart';
import 'package:existimer/core/constants/database_const.dart';

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
      DatabaseTables.taskMeta.taskUuid.name: taskUuid,
      DatabaseTables.taskMeta.createdAt.name: createdAt.millisecondsSinceEpoch,
      DatabaseTables.taskMeta.firstUsedAt.name: firstUsedAt?.millisecondsSinceEpoch,
      DatabaseTables.taskMeta.lastUsedAt.name: lastUsedAt?.millisecondsSinceEpoch,
      DatabaseTables.taskMeta.totalUsedCount.name: totalUsedCount,
      DatabaseTables.taskMeta.totalCount.name: totalCount,
      DatabaseTables.taskMeta.avgSessionDurationMs.name: avgSessionDuration?.inMilliseconds,
      DatabaseTables.taskMeta.icon.name: icon,
      DatabaseTables.taskMeta.baseColor.name: baseColor,
    };
  }

  static TaskMetaSnapshot fromMap(Map<String, dynamic> map) {
    return TaskMetaSnapshot(
      taskUuid: map[DatabaseTables.taskMeta.taskUuid.name],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map[DatabaseTables.taskMeta.createdAt.name]),
      firstUsedAt:
          map[DatabaseTables.taskMeta.firstUsedAt.name] != null
              ? DateTime.fromMillisecondsSinceEpoch(map[DatabaseTables.taskMeta.firstUsedAt.name])
              : null,
      lastUsedAt:
          map[DatabaseTables.taskMeta.lastUsedAt.name] != null
              ? DateTime.fromMillisecondsSinceEpoch(map[DatabaseTables.taskMeta.lastUsedAt.name])
              : null,
      totalUsedCount: map[DatabaseTables.taskMeta.totalUsedCount.name],
      totalCount: map[DatabaseTables.taskMeta.totalCount.name],
      avgSessionDuration:
          map[DatabaseTables.taskMeta.avgSessionDurationMs.name] != null
              ? Duration(milliseconds: map[DatabaseTables.taskMeta.avgSessionDurationMs.name])
              : null,
      icon: map[DatabaseTables.taskMeta.icon.name],
      baseColor: map[DatabaseTables.taskMeta.baseColor.name],
    );
  }
}