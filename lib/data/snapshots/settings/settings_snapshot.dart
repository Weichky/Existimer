import 'package:existimer/data/snapshots/snapshot_base.dart';

import 'package:existimer/common/constants/task_type.dart';
import 'package:existimer/common/constants/timer_unit_type.dart';

class SettingsSnapshot extends SnapshotBase {
  ///外观与语言
  final String? language;

  final bool? enableDarkMode;
  final bool? autoDarkMode;
  final bool? darkModeFollowSystem; /// 未来再加入自订时间

  final String? themeColor;

  /// 声音与通知
  final bool? enableSound;
  final bool? enableFinishedSound;
  final bool? enableNotification;

  /// 调试默认配置
  final bool? enableDebug;
  final bool? enableLog;

  /// 任务默认配置
  final TaskType? defaultTaskType;

  /// 计时默认配置
  final TimerUnitType? defaultTimerUnitType;

  final Duration? countdownDuration;

  final int? taskBatchSize;
  final int? historyBatchSize;

  SettingsSnapshot({
    required this.language,

    required this.enableDarkMode,
    required this.autoDarkMode,
    required this.darkModeFollowSystem,

    required this.themeColor,

    required this.enableSound,
    required this.enableFinishedSound,
    required this.enableNotification,

    required this.enableDebug,
    required this.enableLog,

    required this.defaultTaskType,

    required this.defaultTimerUnitType,

    required this.countdownDuration,

    required this.taskBatchSize,
    required this.historyBatchSize,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'language': language,

      'enable_dark_mode':
          enableDarkMode == null ? null : (enableDarkMode! ? 1 : 0),
      'auto_dark_mode': autoDarkMode == null ? null : (autoDarkMode! ? 1 : 0),
      'dark_mode_follow_system':
          darkModeFollowSystem == null ? null : (darkModeFollowSystem! ? 1 : 0),

      'theme_color': themeColor,

      'enable_sound': enableSound == null ? null : (enableSound! ? 1 : 0),
      'enable_finished_sound':
          enableFinishedSound == null ? null : (enableFinishedSound! ? 1 : 0),
      'enable_notification':
          enableNotification == null ? null : (enableNotification! ? 1 : 0),

      'enable_debug': enableDebug == null ? null : (enableDebug! ? 1 : 0),
      'enable_log': enableLog == null ? null : (enableLog! ? 1 : 0),

      'default_task_type': defaultTaskType?.name,
      'default_timer_unit_type': defaultTimerUnitType?.name,

      'countdown_duration_ms': countdownDuration?.inMilliseconds,
      
      'task_batch_size': taskBatchSize,
      'history_batch_size': historyBatchSize,
    };
  }

  SettingsSnapshot mergeWith(SettingsSnapshot override) {
    return SettingsSnapshot(
      language: override.language ?? language,

      enableDarkMode: override.enableDarkMode ?? enableDarkMode,
      autoDarkMode: override.autoDarkMode ?? autoDarkMode,
      darkModeFollowSystem:
          override.darkModeFollowSystem ?? darkModeFollowSystem,

      themeColor: override.themeColor ?? themeColor,

      enableSound: override.enableSound ?? enableSound,
      enableFinishedSound: override.enableFinishedSound ?? enableFinishedSound,
      enableNotification: override.enableNotification ?? enableNotification,

      enableDebug: override.enableDebug ?? enableDebug,
      enableLog: override.enableLog ?? enableLog,

      defaultTaskType: override.defaultTaskType ?? defaultTaskType,
      defaultTimerUnitType:
          override.defaultTimerUnitType ?? defaultTimerUnitType,

      countdownDuration: override.countdownDuration ?? countdownDuration,
      
      taskBatchSize: override.taskBatchSize ?? taskBatchSize,
      historyBatchSize: override.historyBatchSize ?? historyBatchSize,
    );
  }

  static SettingsSnapshot fromMap(Map<String, dynamic> map) {
    return SettingsSnapshot(
      language: map['language'] as String?,

      enableDarkMode: _boolFromInt(map['enable_dark_mode']),
      autoDarkMode: _boolFromInt(map['auto_dark_mode']),
      darkModeFollowSystem: _boolFromInt(map['dark_mode_follow_system']),

      themeColor: map['theme_color'] as String?,

      enableSound: _boolFromInt(map['enable_sound']),
      enableFinishedSound: _boolFromInt(map['enable_finished_sound']),
      enableNotification: _boolFromInt(map['enable_notification']),

      enableDebug: _boolFromInt(map['enable_debug']),
      enableLog: _boolFromInt(map['enable_log']),

      defaultTaskType:
          map['default_task_type'] == null
              ? null
              : TaskType.fromString(map['default_task_type'] as String?),
      defaultTimerUnitType:
          map['default_timer_unit_type'] == null
              ? null
              : TimerUnitType.fromString(
                map['default_timer_unit_type'] as String?,
              ),

      countdownDuration:
          map['countdown_duration_ms'] == null
              ? null
              : Duration(milliseconds: map['countdown_duration_ms'] as int),
              
      taskBatchSize: map['task_batch_size'] as int?,
      historyBatchSize: map['history_batch_size'] as int?,
    );
  }

  static bool? _boolFromInt(dynamic value) {
    return value == null ? null : value == 1;
  }
}
