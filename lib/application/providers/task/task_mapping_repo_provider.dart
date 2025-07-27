import 'package:existimer/application/providers/repository_provider_factory.dart';
import 'package:existimer/data/repositories/task/task_mapping_sqlite.dart';

/// 任务映射Repository Provider
/// 
/// 提供TaskMappingSqlite实例
/// 使用RepositoryProviderFactory创建，减少重复代码
final taskMappingRepoProvider = RepositoryProviderFactory.createRepositoryProvider<TaskMappingSqlite>(
  (appStartupService) => appStartupService.taskMappingRepo
);