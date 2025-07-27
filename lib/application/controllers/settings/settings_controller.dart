import 'dart:async';

import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/application/providers/settings/settings_repo_provider.dart';
import 'package:existimer/core/constants/default_settings.dart';
import 'package:existimer/data/repositories/settings/settings_sqlite.dart';
import 'package:existimer/snapshots/settings/settings_snapshot.dart';
import 'package:riverpod/riverpod.dart';

class SettingsController extends AsyncNotifier<Settings> {
  late SettingsSqlite _repo;

  @override
  Future<Settings> build() async {
    _repo = await ref.read(settingsRepoProvider.future);

    final loadedSnapshot = await _repo.loadSnapshot();
    final defaultSnapshot = DefaultSettings.toSnapshot();

    final mergedSnapshot =
        loadedSnapshot == null
            ? defaultSnapshot
            : defaultSnapshot.mergeWith(loadedSnapshot);

    return Settings.fromSnapshot(mergedSnapshot);
  }

  // 读取，设置唯一
  Future<void> load() async {
    final SettingsSnapshot? snapshot = await _repo.loadSnapshot();
    if (snapshot != null) {
      state = AsyncData(Settings.fromSnapshot(snapshot));
    } else {
      state = AsyncError(StateError('Cannot load settings from database'), StackTrace.current);
    }
  }

  // 保存
  Future<void> save() async {
    final Settings settings = await future;

    try {
      await _repo.saveSnapshot(settings.toSnapshot());
    } catch (e, st) {
      state = AsyncError(e, st);
    }

  }
}
