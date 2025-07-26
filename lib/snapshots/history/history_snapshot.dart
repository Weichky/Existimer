// history_snapshot.dart

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
      'started_at': startedAt.millisecondsSinceEpoch,
      'session_duration_ms': sessionDuration?.inMilliseconds,
      'count': count,
      'is_archived': isArchived ? 1 : 0,
    };
  }

  static HistorySnapshot fromMap(Map<String, dynamic> map) {
    return HistorySnapshot(
      historyUuid: map['history_uuid'],
      taskUuid: map['task_uuid'],
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['started_at']),
      sessionDuration: map['session_duration_ms'] != null
          ? Duration(milliseconds: map['session_duration_ms'])
          : null,
      count: map['count'],
      isArchived: map['is_archived'] == 1,
    );
  }
}