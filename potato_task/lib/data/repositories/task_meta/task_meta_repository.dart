abstract class TaskMetaRepository {
  Future<void> saveTaskMeta(String taskName);
  Future<String> loadTaskMeta(String uuid);
}