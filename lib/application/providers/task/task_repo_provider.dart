import 'package:existimer/data/repositories/task/task_sqlite.dart';
import 'package:existimer/application/providers/repository_provider_factory.dart';

final taskRepoProvider = RepositoryProviderFactory.createRepositoryProvider<TaskSqlite>(
  (appStartupService) => appStartupService.taskRepo,
);
