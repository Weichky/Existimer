abstract class TaskMetaRepository {
  Future<void> saveTaskName(String taskName);
  Future<String> loadTaskName(String uuid);
}