import 'package:existimer/data/snapshots/task/task_mapping_snapshot.dart';

class TaskMapping {
  String _taskUuid;
  String _entityUuid;
  String _entityType;

  TaskMapping({
    required String taskUuid,
    required String entityUuid,
    required String entityType,
  })  : _taskUuid = taskUuid,
        _entityUuid = entityUuid,
        _entityType = entityType;

  /// Getters
  String get taskUuid => _taskUuid;
  String get entityUuid => _entityUuid;
  String get entityType => _entityType;

  TaskMappingSnapshot toSnapshot() => TaskMappingSnapshot(
        taskUuid: _taskUuid,
        entityUuid: _entityUuid,
        entityType: _entityType,
      );

  factory TaskMapping.fromSnapshot(TaskMappingSnapshot snapshot) {
    return TaskMapping(
      taskUuid: snapshot.taskUuid,
      entityUuid: snapshot.entityUuid,
      entityType: snapshot.entityType,
    );
  }
}