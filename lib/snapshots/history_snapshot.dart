import 'package:existimer/core/constants/task_type.dart';
import 'package:existimer/snapshots/snapshot_base.dart';

class HistorySnapshot extends SnapshotBase {
  String historyUuid;
  String taskUuid;

  DateTime startedAt;
  Duration? sessionDuration;
  int? count;

  bool isArchived;

  HistorySnapshot({
    required this.historyUuid,
    required this.taskUuid,
    required this.startedAt,
    this.sessionDuration,
    this.count,
    required this.isArchived,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'history_uuid': historyUuid,
      'task_uuid': taskUuid,
      'started_at': startedAt,
      'session_duration_ms': sessionDuration,
      'count': count,
      'is_archived': isArchived,
    };
  }

  static HistorySnapshot fromMap(Map<String, dynamic> map) {
    return HistorySnapshot(
      historyUuid: map['history_uuid'],
      taskUuid: map['task_uuid'],
      startedAt: map['started_at'],
      sessionDuration: map['session_duration_ms'],
      count: map['count'],
      isArchived: map['is_archived'],
    );
  }
}