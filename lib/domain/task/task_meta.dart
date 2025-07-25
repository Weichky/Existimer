
class TaskMeta {
  String _taskUuid;

  DateTime _createAt;
  DateTime? _firstUsedAt;
  DateTime? _lastUsedAt;

  int _totalUsedCount;
  Duration? _avgSessionLength;

  String? _icon;

  String? _baseColor;

  String? _description;

  TaskMeta({
    required String taskUuid,

    required DateTime createAt,
    DateTime? firstUsedAt,
    DateTime? lastUsedAt,

    required int totalUsedCount,
    Duration? avgSessionLength,

    String? icon,

    String? baseColor,

    String? description,
  }) : _taskUuid = taskUuid,
      _createAt = createAt,
      _firstUsedAt = firstUsedAt,
      _lastUsedAt = lastUsedAt,
      _totalUsedCount = totalUsedCount,
      _avgSessionLength = avgSessionLength,
      _icon = icon,
      _baseColor = baseColor,
      _description = description;

}
