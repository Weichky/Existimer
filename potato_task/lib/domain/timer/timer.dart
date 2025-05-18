abstract class TimerBase {
  //对于Countup返回totalTime,对于countdown返回remainTime
  Duration duration(DateTime now);
  //用于数据库保存状态，对于Countup返回startTime，对于countdown返回endTime
  DateTime referenceTime();

  bool get isCountup;
  bool get isCountdown;
  bool get isWorking;

  late bool _isWorking;

  void start(DateTime now);
  void stop(DateTime now);
}

class CountupTimer extends TimerBase {
  Duration totalTime;
  DateTime? startTime;

  CountupTimer() : totalTime = Duration() {
    _isWorking = false;
  }

  @override
  Duration duration(DateTime now) {
    assert(
    startTime != null,
    "You must start CountupTimer before calling Duration()."
    );
    return now.difference(startTime!);
  } //上层需保证非空调用

  @override
  DateTime referenceTime() {
    assert(
    startTime != null,
    "You must start CountupTimer before calling referenceTime()."
    );
    return startTime!;
  } //上层需保证非空调用

  @override
  void start(DateTime now) {
    startTime = now;
    _isWorking = true;

  }

  @override
  void stop(DateTime now) {
    assert(
    startTime != null,
    "You must start CountupTimer before calling stop()."
    );
    _isWorking = false;

    totalTime += now.difference(startTime!);
  } //上层需保证非空调用

  void reset() {
    totalTime = Duration();
    startTime = null;
    _isWorking = false;

  }

  @override
  bool get isCountup => true;
  @override
  bool get isCountdown => false;
  @override
  bool get isWorking => _isWorking;
}

class CountdownTimer extends TimerBase {
  Duration remainTime;
  DateTime? endTime;

  CountdownTimer(this.remainTime) {
    _isWorking = false;
  }

  @override
  Duration duration(DateTime now) {
    assert(
    endTime != null,
    "You must start CountdownTimer before calling Duration()."
    );
    return endTime!.difference(now);
  } //上层需保证非空调用

  @override
  DateTime referenceTime() {
    assert(
    endTime != null,
    "You must start CountdownTimer before calling showTime()."
    );
    return endTime!;
  } //上层需保证非空调用

  @override
  void start(DateTime now) {
    endTime = now.add(remainTime);
    _isWorking = true;
  }

  @override
  void stop(DateTime now) {
    assert(
    endTime != null,
    "You must start CountdownTimer before calling stop()."
    );
    _isWorking = false;
    remainTime = endTime!.difference(now);
  } //上层需保证非空调用

  void reset(Duration time) {
    remainTime = time;
    endTime = null;
    _isWorking = false;
  }

  @override
  bool get isCountup => false;
  @override
  bool get isCountdown => true;
  @override
  bool get isWorking => _isWorking;
}
