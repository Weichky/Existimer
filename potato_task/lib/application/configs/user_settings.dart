import 'package:potato_task/core/constants/task_type.dart';
import 'package:potato_task/core/constants/timer_unit_type.dart';

class UserSettings {
  //外观与语言
  String? language;

  bool? enableDarkMode;
  bool? autoDarkMode;
  bool? darkModeFollowSystem; // 未来再加入自订时间

  String? themeColor;

  // 声音与通知
  bool? enableSound;
  bool? enableFinishedSound;
  bool? enableNotification;

  // 调试默认配置
  bool? enableDebug;
  bool? enableLog;

  // 任务默认配置
  TaskType? defaultTaskType;

  // 计时默认配置
  TimerUnitType? defaultTimerUnitType;

  Duration? countdownDuration;
  int? countdownDurationSeconds;
}