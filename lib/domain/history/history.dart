// history.dart
import 'package:existimer/core/utils/helper.dart';

class History {
  String _historyUuid;
  String _taskUuid;

  DateTime _startedAt;
  Duration? _sessionDuration;
  int? _counts;

  bool _isArchived;

  History({
    required String taskUuid,
    required DateTime startedAt,
    Duration? sessionDuration,
    int? counts,
    required bool isArchived,
  }) : _historyUuid = UuidHelper.getUuid(),
       _taskUuid = taskUuid,
       _startedAt = startedAt,
       _sessionDuration = sessionDuration,
       _counts = counts,
       _isArchived = isArchived;
}