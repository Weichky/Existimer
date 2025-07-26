import 'dart:async';

import 'package:existimer/application/configs/user_settings.dart';
import 'package:existimer/application/providers/user_settings_repo_provider.dart';
import 'package:existimer/core/constants/default_settings.dart';
import 'package:existimer/data/repositories/configs/user_settings_sqlite.dart';
import 'package:existimer/snapshots/user_settings_snapshot.dart';
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

  // 读取，设置唯一
  Future<void> load() async {
    final UserSettingsSnapshot? snapshot = await _repo.loadSnapshot();
    if (snapshot != null) {
      state = AsyncData(UserSettings.fromSnapshot(snapshot));
    } else {
      state = AsyncError(StateError('Cannot load settings from database'), StackTrace.current);
    }
  }

  // 保存
  Future<void> save() async {
    final UserSettings settings = await future;

    try {
      await _repo.saveSnapshot(settings.toSnapshot());
    } catch (e, st) {
      state = AsyncError(e, st);
    }

  }
}
