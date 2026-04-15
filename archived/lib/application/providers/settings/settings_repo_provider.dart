// user_settings_repo_provider.dart
import 'package:existimer/application/providers/repository_provider_factory.dart';
import 'package:existimer/data/repositories/settings/settings_sqlite.dart';

/// 用户设置Repository Provider
///
/// 提供SettingsSqlite实例
/// 使用RepositoryProviderFactory创建，减少重复代码
final settingsRepoProvider = RepositoryProviderFactory.createRepositoryProvider<SettingsSqlite>(
  (appStartupService) => appStartupService.settingsRepo
);