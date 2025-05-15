import 'package:potato_task/snapshots/meta_snapshot.dart';

abstract class TaskMetaRepository {
  Future<void> saveTaskMeta(TaskMetaSnapshot taskMetaSnapshot);
  Future<TaskMetaSnapshot> loadTaskMeta(String uuid);
}