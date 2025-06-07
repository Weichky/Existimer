//settings_provider.dart
import 'package:existimer/application/providers/user_settings_repo_provider.dart';
import 'package:existimer/snapshots/user_settings_snapshot.dart';
import 'package:riverpod/riverpod.dart';

import 'package:existimer/core/constants/default_config.dart';

final settingsProvider = FutureProvider<UserSettingsSnapshot>((ref) async {
  final repo = await ref.watch(userSettingsRepoProvider.future);
  final userSettings = await repo.loadSnapshot();

  final defaultSettings = DefaultSettings.toSnapshot();

  if (userSettings == null) {
    return defaultSettings;
  }

  return defaultSettings.mergeWith(userSettings);
});