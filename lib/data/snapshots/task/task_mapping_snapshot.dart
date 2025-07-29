import 'package:existimer/data/snapshots/snapshot_base.dart';
import 'package:existimer/core/constants/database_const.dart';

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
      DatabaseTables.taskMapping.taskUuid.name: taskUuid,
      DatabaseTables.taskMapping.entityUuid.name: entityUuid,
      DatabaseTables.taskMapping.entityType.name: entityType,
    };
  }

  static TaskMappingSnapshot fromMap(Map<String, dynamic> map) {
    return TaskMappingSnapshot(
      taskUuid: map[DatabaseTables.taskMapping.taskUuid.name],
      entityUuid: map[DatabaseTables.taskMapping.entityUuid.name],
      entityType: map[DatabaseTables.taskMapping.entityType.name],
    );
  }
}