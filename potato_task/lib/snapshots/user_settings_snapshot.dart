import 'package:potato_task/snapshots/snapshot_base.dart';

import 'package:potato_task/core/constants/task_type.dart';
import 'package:potato_task/core/constants/timer_unit_type.dart';

class UserSettingsSnapshot extends SnapshotBase {
  //外观与语言
  final String? language;

  final bool? enableDarkMode;
  final bool? autoDarkMode;
  final bool? darkModeFollowSystem; // 未来再加入自订时间

  final String? themeColor;

  // 声音与通知
  final bool? enableSound;
  final bool? enableFinishedSound;
  final bool? enableNotification;

  // 调试默认配置
  final bool? enableDebug;
  final bool? enableLog;

  // 任务默认配置
  final TaskType? defaultTaskType;

  // 计时默认配置
  final TimerUnitType? defaultTimerUnitType;

  final Duration? countdownDuration;

  UserSettingsSnapshot({
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

      'countdown_duration': countdownDuration?.inMilliseconds,
    };
  }

  static UserSettingsSnapshot fromMap(Map<String, dynamic> map) {
    return UserSettingsSnapshot(
      language: map['language'] as String?,

      enableDarkMode:
          map['enable_dark_mode'] == null
              ? null
              : (map['enable_dark_mode'] == 1),
      autoDarkMode:
          map['auto_dark_mode'] == null ? null : (map['auto_dark_mode'] == 1),
      darkModeFollowSystem:
          map['dark_mode_follow_system'] == null
              ? null
              : (map['dark_mode_follow_system'] == 1),

      themeColor: map['theme_color'] as String?,

      enableSound:
          map['enable_sound'] == null ? null : (map['enable_sound'] == 1),
      enableFinishedSound:
          map['enable_finished_sound'] == null
              ? null
              : (map['enable_finished_sound'] == 1),
      enableNotification:
          map['enable_notification'] == null
              ? null
              : (map['enable_notification'] == 1),

      enableDebug:
          map['enable_debug'] == null ? null : (map['enable_debug'] == 1),
      enableLog: map['enable_log'] == null ? null : (map['enable_log'] == 1),

      defaultTaskType: TaskType.fromString(
        map['default_task_type'] as String?,
      ),
      defaultTimerUnitType: TimerUnitType.fromString(
        map['default_timer_unit_type'] as String?,
      ),

      countdownDuration:
          map['countdown_duration'] == null
              ? null
              : Duration(milliseconds: map['countdown_duration'] as int),
    );
  }
}