// user_settings_repo_provider.dart
import 'package:existimer/data/repositories/settings/settings_sqlite.dart';
import 'package:riverpod/riverpod.dart';
import 'app_startup_service_provider.dart';

final userSettingsRepoProvider = FutureProvider<SettingsSqlite>((ref) {
  final appStartupService = ref.watch(appStartupServiceReadyProvider);
  return appStartupService.settingsRepo;
});