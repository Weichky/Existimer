class TaskMeta {
  String _taskUuid;

  DateTime _createAt;
  DateTime? _firstUsedAt;
  DateTime? _lastUsedAt;

  int _totalUsedCount; // 作为任务完成的次数

  int? _totalCount; // 记次任务的总次数
  Duration? _avgSessionDuration;

  String? _icon;

  String? _baseColor;

  TaskMeta({
    required String taskUuid,
    required DateTime createAt,
    DateTime? firstUsedAt,
    DateTime? lastUsedAt,
    required int totalUsedCount,
    int? totalCount,
    Duration? avgSessionDuration,
    String? icon,
    String? baseColor,
    String? description,
  }) : _taskUuid = taskUuid,
       _createAt = createAt,
       _firstUsedAt = firstUsedAt,
       _lastUsedAt = lastUsedAt,
       _totalUsedCount = totalUsedCount,
       _totalCount = totalCount,
       _avgSessionDuration = avgSessionDuration,
       _icon = icon,
       _baseColor = baseColor;
}
