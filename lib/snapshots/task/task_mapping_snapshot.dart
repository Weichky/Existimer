import 'package:existimer/snapshots/snapshot_base.dart';

class TaskMappingSnapshot extends SnapshotBase {
  final String taskUuid;
  final String entityUuid;
  final String entityType;

  TaskMappingSnapshot({
    required this.taskUuid,
    required this.entityUuid,
    required this.entityType,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'task_uuid': taskUuid,
      'entity_uuid': entityUuid,
      'entity_type': entityType,
    };
  }

  static TaskMappingSnapshot fromMap(Map<String, dynamic> map) {
    return TaskMappingSnapshot(
      taskUuid: map['task_uuid'],
      entityUuid: map['entity_uuid'],
      entityType: map['entity_type'],
    );
  }
}