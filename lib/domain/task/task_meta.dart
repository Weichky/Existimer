import 'package:existimer/data/snapshots/task/task_meta_snapshot.dart';

class TaskMeta {
  String _taskUuid;

  DateTime _createdAt;
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
       _createdAt = createAt,
       _firstUsedAt = firstUsedAt,
       _lastUsedAt = lastUsedAt,
       _totalUsedCount = totalUsedCount,
       _totalCount = totalCount,
       _avgSessionDuration = avgSessionDuration,
       _icon = icon,
       _baseColor = baseColor;

  factory TaskMeta.fromSnapshot(TaskMetaSnapshot snapshot) {
    final meta = TaskMeta(
      taskUuid: snapshot.taskUuid,
      createAt: snapshot.createdAt,
      totalUsedCount: snapshot.totalUsedCount,
    );

    meta.fromSnapshot(snapshot);
    return meta;
  }

  // setter
  set setFirstUsedAt(DateTime dateTime) {
    _firstUsedAt = dateTime;
  }

  set setLastUsedAt(DateTime dateTime) {
    _lastUsedAt = dateTime;
  }

  set setIcon(String icon) {
    _icon = icon;
  }

  set setBaseColor(String color) {
    _baseColor = color;
  }

  TaskMetaSnapshot toSnapshot() => TaskMetaSnapshot(
    taskUuid: _taskUuid,
    createdAt: _createdAt,
    firstUsedAt: _firstUsedAt,
    lastUsedAt: _lastUsedAt,
    totalUsedCount: _totalUsedCount,
    totalCount: _totalCount,
    avgSessionDuration: _avgSessionDuration,
    icon: _icon,
    baseColor: _baseColor,
  );

  void fromSnapshot(TaskMetaSnapshot snapshot) {
    _taskUuid = snapshot.taskUuid;
    _createdAt = snapshot.createdAt;
    _firstUsedAt = snapshot.firstUsedAt;
    _lastUsedAt = snapshot.lastUsedAt;
    _totalUsedCount = snapshot.totalUsedCount;
    _totalCount = snapshot.totalCount;
    _avgSessionDuration = snapshot.avgSessionDuration;
    _icon = snapshot.icon;
    _baseColor = snapshot.baseColor;
  }
}
