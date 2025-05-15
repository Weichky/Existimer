import 'package:potato_task/snapshots/task_meta_snapshot.dart';

abstract class TaskMetaRepository {
  Future<void> saveTaskMeta(TaskMetaSnapshot taskMetaSnapshot);
  Future<TaskMetaSnapshot> loadTaskMeta(String uuid);
}