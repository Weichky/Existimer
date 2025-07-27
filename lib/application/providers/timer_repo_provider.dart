// timer_repo_provider.dart
import 'package:existimer/application/providers/repository_provider_factory.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';

/// 计时器单元Repository Provider
/// 
/// 提供TimerUnitSqlite实例
/// 使用RepositoryProviderFactory创建，减少重复代码
final timerRepoProvider = RepositoryProviderFactory.createRepositoryProvider<TimerUnitSqlite>(
  (appStartupService) => appStartupService.timerRepo
);
