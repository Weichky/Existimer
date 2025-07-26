import 'package:existimer/core/constants/task_type.dart';
import 'package:existimer/core/constants/timer_unit_type.dart';

import 'package:existimer/snapshots/settings/settings_snapshot.dart';

class Settings {
  //外观与语言
  String? _language;

  bool? _enableDarkMode;
  bool? _autoDarkMode;
  bool? _darkModeFollowSystem; // 未来再加入自订时间

  String? _themeColor;

  // 声音与通知
  bool? _enableSound;
  bool? _enableFinishedSound;
  bool? _enableNotification;

  // 调试默认配置
  bool? _enableDebug;
  bool? _enableLog;

  // 任务默认配置
  TaskType? _defaultTaskType;

  // 计时默认配置
  TimerUnitType? _defaultTimerUnitType;

  Duration? _countdownDuration;

  Settings({
    String? language,
    bool? enableDarkMode,
    bool? autoDarkMode,
    bool? darkModeFollowSystem,
    String? themeColor,
    bool? enableSound,
    bool? enableFinishedSound,
    bool? enableNotification,
    bool? enableDebug,
    bool? enableLog,
    TaskType? defaultTaskType,
    TimerUnitType? defaultTimerUnitType,
    Duration? countdownDuration,
  }) : _language = language,
       _enableDarkMode = enableDarkMode,
       _autoDarkMode = autoDarkMode,
       _darkModeFollowSystem = darkModeFollowSystem,
       _themeColor = themeColor,
       _enableSound = enableSound,
       _enableFinishedSound = enableFinishedSound,
       _enableNotification = enableNotification,
       _enableDebug = enableDebug,
       _enableLog = enableLog,
       _defaultTaskType = defaultTaskType,
       _defaultTimerUnitType = defaultTimerUnitType,
       _countdownDuration = countdownDuration;

  SettingsSnapshot toSnapshot() {
    return SettingsSnapshot(
      language: _language,
      enableDarkMode: _enableDarkMode,
      autoDarkMode: _autoDarkMode,
      darkModeFollowSystem: _darkModeFollowSystem,
      themeColor: _themeColor,
      enableSound: _enableSound,
      enableFinishedSound: _enableFinishedSound,
      enableNotification: _enableNotification,
      enableDebug: _enableDebug,
      enableLog: _enableLog,
      defaultTaskType: _defaultTaskType,
      defaultTimerUnitType: _defaultTimerUnitType,
      countdownDuration: _countdownDuration,
    );
  }

  void fromSnapshot(SettingsSnapshot userSettingsSnapshot) {
    _language = userSettingsSnapshot.language;
    _enableDarkMode = userSettingsSnapshot.enableDarkMode;
    _autoDarkMode = userSettingsSnapshot.autoDarkMode;
    _darkModeFollowSystem = userSettingsSnapshot.darkModeFollowSystem;
    _themeColor = userSettingsSnapshot.themeColor;
    _enableSound = userSettingsSnapshot.enableSound;
    _enableFinishedSound = userSettingsSnapshot.enableFinishedSound;
    _enableNotification = userSettingsSnapshot.enableNotification;
    _enableDebug = userSettingsSnapshot.enableDebug;
    _enableLog = userSettingsSnapshot.enableLog;
    _defaultTaskType = userSettingsSnapshot.defaultTaskType;
    _defaultTimerUnitType = userSettingsSnapshot.defaultTimerUnitType;
    _countdownDuration = userSettingsSnapshot.countdownDuration;
  }

  factory Settings.fromSnapshot(SettingsSnapshot userSettingsSnapshot) {
    final settings = Settings();
    settings.fromSnapshot(userSettingsSnapshot);
    return settings;
  }

  // getter
  String? get language => _language;
  bool? get enableDarkMode => _enableDarkMode;
  bool? get autoDarkMode => _autoDarkMode;
  bool? get darkModeFollowSystem => _darkModeFollowSystem;
  String? get themeColor => _themeColor;
  bool? get enableSound => _enableSound;
  bool? get enableFinishedSound => _enableFinishedSound;
  bool? get enableNotification => _enableNotification;
  bool? get enableDebug => _enableDebug;
  bool? get enableLog => _enableLog;
  TaskType? get defaultTaskType => _defaultTaskType;
  TimerUnitType? get defaultTimerUnitType => _defaultTimerUnitType;
  Duration? get countdownDuration => _countdownDuration;
}
