import 'package:existimer/application/providers/settings/settings_provider.dart';
import 'package:existimer/common/constants/default_settings.dart';
import 'package:existimer/data/repositories/settings/settings_sqlite.dart';
import 'package:existimer/domain/task/task.dart';
import 'package:existimer/application/controllers/collection_controller.dart';
import 'package:existimer/data/repositories/task/task_sqlite.dart';
import 'package:existimer/application/providers/task/task_repo_provider.dart';
import 'package:existimer/application/settings/settings.dart';

class TaskController extends CollectionController<Task> {
  late TaskSqlite _repo;
  late Settings _settings;
  late int _batchSize;

  @override
  Future<List<Task>> build() async {
    _repo = await ref.read(taskRepoProvider.future);
    _settings = await ref.watch(settingsProvider.future);
    _batchSize = _settings.taskBatchSize ?? DefaultSettings.taskBatchSize;
    return [];
  }
}