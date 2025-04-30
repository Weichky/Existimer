import 'package:potato_task/core/services/clock.dart';

abstract class TimerBase {
  bool _isActive;

  Clock clock;
  TimerBase(this._isActive) : clock = Clock();

  //对于forward返回totalTime,对于countdown返回remainTime
  Duration duration();
  //用于数据库保存状态，对于forward返回startTime，对于countdown返回endTime
  DateTime showTime();
  void update();
  void start();
  void stop();

  bool get isForward;
  bool get isCountdown;
  bool get isActive => _isActive;
}

class ForwardTimer extends TimerBase {
  Duration totalTime;
  DateTime? startTime;

  ForwardTimer() :
  totalTime = Duration(),
  super(false);

  @override
  Duration duration() {
    assert(startTime != null,"ForwardTimer must be started at once before calling Duration().");
    return clock.currentTime.difference(startTime!);
  }//上层需保证非空调用

  @override
  DateTime showTime() {
    assert(startTime != null,"ForwardTimer must be started at once before calling showTime().");
    return startTime!;
  }//上层需保证非空调用

  @override
  void update() {
    startTime = clock.currentTime;
  }//更新开始时间

  @override
  void start() {
    if (_isActive) {
      return;
    }

    update();

    _isActive = true;
  }

  @override
  void stop() {
    if (!_isActive) {
      return;
    }

    totalTime += clock.currentTime.difference(startTime!);

    _isActive = false;
  }//上层需保证非空调用

  void reset() {
    totalTime = Duration();
    startTime = null;
  }

  @override
  bool get isForward => true;
  @override
  bool get isCountdown => false;
}

class CountdownTimer extends TimerBase {
  Duration remainTime;
  DateTime? endTime;

  CountdownTimer(this.remainTime) : super(false);

  @override
  Duration duration() {
    assert(
      endTime != null,
      "CountdownTimer must be started at once before calling Duration().",
    );
    return clock.currentTime.difference(endTime!);
  } //上层需保证非空调用

  @override
  DateTime showTime() {
    assert(
      endTime != null,
      "CountdownTimer must be started at once before calling showTime().",
    );
    return endTime!;
  } //上层需保证非空调用

  @override
  void update() {
    endTime = clock.currentTime.add(remainTime);
  } //更新开始时间

  @override
  void start() {
    if (_isActive) {
      return;
    }

    update();

    _isActive = true;
  }

  @override
  void stop() {
    if (!_isActive) {
      return;
    }

    remainTime = endTime!.difference(clock.currentTime);

    _isActive = false;
  } //上层需保证非空调用

  void reset() {
    remainTime = Duration();
    endTime = null;
  }

  @override
  bool get isForward => true;
  @override
  bool get isCountdown => false;
}
