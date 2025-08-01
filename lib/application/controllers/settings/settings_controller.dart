import 'dart:async';

import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/application/providers/settings/settings_repo_provider.dart';
import 'package:existimer/common/constants/default_settings.dart';
import 'package:existimer/common/constants/task_type.dart';
import 'package:existimer/common/constants/timer_unit_type.dart';
import 'package:existimer/data/repositories/settings/settings_sqlite.dart';
import 'package:existimer/data/snapshots/settings/settings_snapshot.dart';
import 'package:riverpod/riverpod.dart';

class SettingsController extends AsyncNotifier<Settings> {
  late SettingsSqlite _repo;

  @override
  Future<Settings> build() async {
    _repo = await ref.read(settingsRepoProvider.future);

    final loadedSnapshot = await _repo.queryByUuid();
    final defaultSnapshot = DefaultSettings.toSnapshot();

    final mergedSnapshot =
        loadedSnapshot == null
            ? defaultSnapshot
            : defaultSnapshot.mergeWith(loadedSnapshot);
            
    return Settings.fromSnapshot(mergedSnapshot);
  }

  /// 读取，设置唯一
  Future<void> load() async {
    final SettingsSnapshot? snapshot = await _repo.queryByUuid();
    if (snapshot != null) {
      state = AsyncData(Settings.fromSnapshot(snapshot));
    } else {
      state = AsyncError(StateError('Cannot load settings from database'), StackTrace.current);
    }
  }

  /// 保存
  Future<void> save() async {
    final Settings settings = await future;

    try {
      await _repo.saveSnapshot(settings.toSnapshot());
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  /// Setters
  Future<void> setLanguage(String? language) async {
    final settings = state.requireValue;
    try {
      settings.language = language; /// 使用属性赋值语法而不是方法调用
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setEnableDarkMode(bool? enableDarkMode) async {
    final settings = state.requireValue;
    try {
      settings.enableDarkMode = enableDarkMode;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setAutoDarkMode(bool? autoDarkMode) async {
    final settings = state.requireValue;
    try {
      settings.autoDarkMode = autoDarkMode;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setDarkModeFollowSystem(bool? darkModeFollowSystem) async {
    final settings = state.requireValue;
    try {
      settings.darkModeFollowSystem = darkModeFollowSystem;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setThemeColor(String? themeColor) async {
    final settings = state.requireValue;
    try {
      settings.themeColor = themeColor;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setEnableSound(bool? enableSound) async {
    final settings = state.requireValue;
    try {
      settings.enableSound = enableSound;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setEnableFinishedSound(bool? enableFinishedSound) async {
    final settings = state.requireValue;
    try {
      settings.enableFinishedSound = enableFinishedSound;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setEnableNotification(bool? enableNotification) async {
    final settings = state.requireValue;
    try {
      settings.enableNotification = enableNotification;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setEnableDebug(bool? enableDebug) async {
    final settings = state.requireValue;
    try {
      settings.enableDebug = enableDebug;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setEnableLog(bool? enableLog) async {
    final settings = state.requireValue;
    try {
      settings.enableLog = enableLog;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setDefaultTaskType(TaskType? defaultTaskType) async {
    final settings = state.requireValue;
    try {
      settings.defaultTaskType = defaultTaskType;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setDefaultTimerUnitType(TimerUnitType? defaultTimerUnitType) async {
    final settings = state.requireValue;
    try {
      settings.defaultTimerUnitType = defaultTimerUnitType;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  Future<void> setCountdownDuration(Duration? countdownDuration) async {
    final settings = state.requireValue;
    try {
      settings.countdownDuration = countdownDuration;
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}