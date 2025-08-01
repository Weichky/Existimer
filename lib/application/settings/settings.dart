import 'package:existimer/common/constants/task_type.dart';
import 'package:existimer/common/constants/timer_unit_type.dart';

import 'package:existimer/data/snapshots/settings/settings_snapshot.dart';

class Settings {
  ///外观与语言
  String? _language;

  bool? _enableDarkMode;
  bool? _autoDarkMode;
  bool? _darkModeFollowSystem; /// 未来再加入自订时间

  String? _themeColor;

  /// 声音与通知
  bool? _enableSound;
  bool? _enableFinishedSound;
  bool? _enableNotification;

  /// 调试默认配置
  bool? _enableDebug;
  bool? _enableLog;

  /// 任务默认配置
  TaskType? _defaultTaskType;

  /// 计时默认配置
  TimerUnitType? _defaultTimerUnitType;

  Duration? _countdownDuration;

  /// 一次性加载数量配置
  int? _taskBatchSize;
  int? _historyBatchSize;

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
    int? taskBatchSize,
    int? historyBatchSize,
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
       _countdownDuration = countdownDuration,
       _taskBatchSize = taskBatchSize,
       _historyBatchSize = historyBatchSize;

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
      taskBatchSize: _taskBatchSize,
      historyBatchSize: _historyBatchSize,
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
    _taskBatchSize = userSettingsSnapshot.taskBatchSize;
    _historyBatchSize = userSettingsSnapshot.historyBatchSize;
  }

  factory Settings.fromSnapshot(SettingsSnapshot userSettingsSnapshot) {
    final settings = Settings();
    settings.fromSnapshot(userSettingsSnapshot);
    return settings;
  }

  /// getter
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
  int? get taskBatchSize => _taskBatchSize;
  int? get historyBatchSize => _historyBatchSize;
  
  set language(String? language) {
    _language = language;
  }
  
  set enableDarkMode(bool? enableDarkMode) {
    _enableDarkMode = enableDarkMode;
  }
  
  set autoDarkMode(bool? autoDarkMode) {
    _autoDarkMode = autoDarkMode;
  }
  
  set darkModeFollowSystem(bool? darkModeFollowSystem) {
    _darkModeFollowSystem = darkModeFollowSystem;
  }
  
  set themeColor(String? themeColor) {
    _themeColor = themeColor;
  }
  
  set enableSound(bool? enableSound) {
    _enableSound = enableSound;
  }
  
  set enableFinishedSound(bool? enableFinishedSound) {
    _enableFinishedSound = enableFinishedSound;
  }
  
  set enableNotification(bool? enableNotification) {
    _enableNotification = enableNotification;
  }
  
  set enableDebug(bool? enableDebug) {
    _enableDebug = enableDebug;
  }
  
  set enableLog(bool? enableLog) {
    _enableLog = enableLog;
  }
  
  set defaultTaskType(TaskType? defaultTaskType) {
    _defaultTaskType = defaultTaskType;
  }
  
  set defaultTimerUnitType(TimerUnitType? defaultTimerUnitType) {
    _defaultTimerUnitType = defaultTimerUnitType;
  }
  
  set countdownDuration(Duration? countdownDuration) {
    _countdownDuration = countdownDuration;
  }
  
  set taskBatchSize(int? taskBatchSize) {
    _taskBatchSize = taskBatchSize;
  }
  
  set historyBatchSize(int? historyBatchSize) {
    _historyBatchSize = historyBatchSize;
  }
}
