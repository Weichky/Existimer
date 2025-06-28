import 'dart:async';

import 'package:existimer/application/configs/user_settings.dart';
import 'package:existimer/application/providers/user_settings_repo_provider.dart';
import 'package:existimer/core/constants/default_config.dart';
import 'package:existimer/data/repositories/configs/user_settings_sqlite.dart';
import 'package:riverpod/riverpod.dart';

class ConfigController extends AsyncNotifier<UserSettings> {
  late UserSettingsSqlite _repo;

  @override
  Future<UserSettings> build() async {
    _repo = await ref.read(userSettingsRepoProvider.future);

    final loadedSnapshot = await _repo.loadSnapshot();
    final defaultSnapshot = DefaultSettings.toSnapshot();

    final mergedSnapshot =
        loadedSnapshot == null
            ? defaultSnapshot
            : defaultSnapshot.mergeWith(loadedSnapshot);

    return UserSettings.fromSnapshot(mergedSnapshot);
  }

  Future<void> save() async {}
}
