// history_snapshot.dart

import 'package:existimer/data/snapshots/snapshot_base.dart';
import 'package:existimer/common/constants/database_const.dart';

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
      DatabaseTables.history.historyUuid.name: historyUuid,
      DatabaseTables.history.taskUuid.name: taskUuid,
      DatabaseTables.history.startedAt.name: startedAt.millisecondsSinceEpoch,
      DatabaseTables.history.sessionDurationMs.name: sessionDuration?.inMilliseconds,
      DatabaseTables.history.count.name: count,
      DatabaseTables.history.isArchived.name: isArchived ? 1 : 0,
    };
  }

  static HistorySnapshot fromMap(Map<String, dynamic> map) {
    return HistorySnapshot(
      historyUuid: map[DatabaseTables.history.historyUuid.name],
      taskUuid: map[DatabaseTables.history.taskUuid.name],
      startedAt: DateTime.fromMillisecondsSinceEpoch(map[DatabaseTables.history.startedAt.name]),
      sessionDuration: map[DatabaseTables.history.sessionDurationMs.name] != null
          ? Duration(milliseconds: map[DatabaseTables.history.sessionDurationMs.name])
          : null,
      count: map[DatabaseTables.history.count.name],
      isArchived: map[DatabaseTables.history.isArchived.name] == 1,
    );
  }
}