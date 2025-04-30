import 'package:potato_task/core/constants/timer_status.dart';
import 'package:potato_task/core/constants/timer_type.dart';

import 'package:potato_task/core/services/clock.dart';

//要重新设计Timer
//添加snapshot,来保证数据持久化
abstract class TimerBase {
  TimerType timerType;
  TimerStatus status;

  Clock clock;
  TimerBase(this.timerType) :
  status = TimerStatus.inactive,
  clock = Clock();

  //对于forward返回totalTime,对于countdown返回remainTime
  Duration duration();
  //用于数据库保存状态，对于forward返回startTime，对于countdown返回endTime
  DateTime showTime();
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
  Duration duration() {
    if (status.isActive && startTime != null) {
      return clock.currentTime.difference(startTime!);
    }
    return totalTime;
  }

  @override
  DateTime showTime() => startTime ??
    (throw StateError("ForwardTimer must be started at once before calling showTime()."));

  @override
  void update() {
    startTime = clock.currentTime;
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
          totalTime += clock.currentTime.difference(startTime!);
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
  Duration duration() {
    if (status.isActive && endTime != null) {
      return endTime!.difference(clock.currentTime);
    }
    return remainTime;
  }

  @override
  DateTime showTime() => endTime ??
    (throw StateError("CountdownTimer must be started at once before calling showTime()."));

  @override
  void update() {
    endTime = clock.currentTime.add(remainTime);
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
        remainTime = endTime!.difference(clock.currentTime);
        status = TimerStatus.paused;
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

    if (status.isActive) {
      pause();
    }
  
    status = TimerStatus.inactive;
  }


  void reset(Duration duration) {
      remainTime = duration;
      endTime = null;
  }
}