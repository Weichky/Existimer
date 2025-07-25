// history.dart
import 'package:existimer/core/utils/helper.dart';
import 'package:existimer/snapshots/history_snapshot.dart';

class History {
  String _historyUuid;
  String _taskUuid;

  DateTime _startedAt;
  Duration? _sessionDuration;
  int? _count;

  bool _isArchived;

  History({
    required String taskUuid,
    required DateTime startedAt,
    Duration? sessionDuration,
    int? count,
    required bool isArchived,
  }) : _historyUuid = UuidHelper.getUuid(),
       _taskUuid = taskUuid,
       _startedAt = startedAt,
       _sessionDuration = sessionDuration,
       _count = count,
       _isArchived = isArchived;

  factory History.fromSnapshot(HistorySnapshot snapshot) {
    
  }

  // setter
  set setSessionDuration(Duration duration) {
    _sessionDuration = duration;
  }

  void addToCount({int addition = 1}) {
    if (_count != null) {
      _count = _count! + 1;
    } else {
      throw(StateError('Cannot add $addition to _count because _count is null.'));
    }
  }

  // getter
  String get historyUuid => _historyUuid;
  String get taskUuid => _taskUuid;
  DateTime get startedAt => _startedAt;
  Duration? get sessionDuration => _sessionDuration;
  int? get count => _count;
  bool get isArchived => _isArchived;

  HistorySnapshot toSnapshot() => HistorySnapshot(
    historyUuid: _historyUuid,
    taskUuid: _taskUuid,
    startedAt: _startedAt,
    sessionDuration: _sessionDuration,
    count: _count,
    isArchived: _isArchived,
  );
}