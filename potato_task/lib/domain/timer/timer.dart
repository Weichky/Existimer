import 'package:potato_task/core/constants/timer_status.dart';
import 'package:potato_task/core/constants/timer_type.dart';
import 'package:potato_task/core/utils/helper.dart';
import 'package:potato_task/core/config.dart';

abstract class TimerBase {
  TimerType timerType;
  TimerStatus status;
  final String uuid;
  TimerBase(this.timerType) :
  status = TimerStatus.inactive,
  uuid = UuidHelper.getUuid();

  void show();
  void update();
  void start();
  void pause();
  void stop();
}

class ForwardTimer extends TimerBase {
  Duration totalTime;
  DateTime? startTime;

  ForwardTimer() :
    totalTime = Duration(),
    super(TimerType.forward);

  @override
  Duration show() {
    if (status.isActive && startTime != null) {
      return DateTime.now().difference(startTime!);
    }
    return totalTime;
  }


  @override
  void update() {
    startTime = DateTime.now();
  }
  //更新开始时间

  @override
  void start() {
    if (status.isActive) {
      return;
    }

    update();

    status = TimerStatus.active;
  }

  @override
  void pause() {
    if (status.isActive) {
      // 冗余保障
        if (startTime != null) {
          totalTime += DateTime.now().difference(startTime!);
        } else {
          throw StateError("Timer must be started once before paused.");
        }
        status = TimerStatus.paused;
    }

    return;
  }

  @override
  void stop() {
    if (status.isInactive) {
      return;
    }

    pause();

    status = TimerStatus.inactive;
  }

  void reset() {
    totalTime = Duration();
    startTime = null;
  }
}

class CountdownTimer extends TimerBase {
  Duration remainTime;
  DateTime? endTime;

  CountdownTimer(this.remainTime) :
    super(TimerType.countdown);

  @override
  Duration show() {
    if (status.isActive && endTime != null) {
      return endTime!.difference(DateTime.now());
    }
    return remainTime;
  }


  @override
  void update() {
    endTime = DateTime.now().add(remainTime);
  }
  //更新结束时间

  @override
  void start() {
    if (status.isActive) {
      return;
    }

    update();

    status = TimerStatus.active;
  }

  @override
  void pause() {
    if (status.isActive) {
      if (endTime != null) {
        //实际上有可能小于0,留给控制模块，便于处理超时问题
        remainTime = endTime!.difference(DateTime.now());
      } else {
        throw StateError("Timer must be started once before paused.");
      }
    }

    return;
  }

  @override
  void stop() {
    if (status.isInactive) {
      return;
    }

    pause();

    status = TimerStatus.inactive;
  }

  void reset([Duration? duration]) {
    if (duration != null) {
      remainTime = duration;
      endTime = null;
    } else {
      remainTime = DEFAULT_REMAIN_TIME;
      endTime = null;
    }
  }
}