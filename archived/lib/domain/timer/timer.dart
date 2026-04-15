abstract class TimerBase {
  ///对于Countup返回totalDuration,对于countdown返回remainDuration
  Duration duration(DateTime now);
  ///用于数据库保存状态，对于Countup返回startTime，对于countdown返回endTime
  DateTime referenceTime();

  bool get isCountup;
  bool get isCountdown;

  void start(DateTime now);
  void stop(DateTime now);
}

class CountupTimer extends TimerBase {
  Duration _totalDuration;
  DateTime? _startTime;

  CountupTimer() : _totalDuration = Duration();

  @override
  Duration duration(DateTime now) {
    assert(
    _startTime != null,
    "You must start CountupTimer before calling Duration()."
    );
    return _totalDuration;
  } ///上层需保证非空调用

  @override
  DateTime referenceTime() {
    assert(
    _startTime != null,
    "You must start CountupTimer before calling referenceTime()."
    );
    return _startTime!;
  } ///上层需保证非空调用

  @override
  void start(DateTime now) {
    _startTime = now;
  }

  @override
  void stop(DateTime now) {
    assert(
    _startTime != null,
    "You must start CountupTimer before calling stop()."
    );

    _totalDuration += now.difference(_startTime!);
  } ///上层需保证非空调用

  void reset() {
    _totalDuration = Duration();
    _startTime = null;
  }

  @override
  bool get isCountup => true;
  @override
  bool get isCountdown => false;

  set totalDuration(Duration duration) {
    _totalDuration = duration;
  }

  set startTime(DateTime time) {
    _startTime = time;
  }
}

class CountdownTimer extends TimerBase {
  Duration _remainDuration;
  DateTime? _endTime;

  CountdownTimer(this._remainDuration);

  @override
  Duration duration(DateTime now) {
    assert(
    _endTime != null,
    "You must start CountdownTimer before calling Duration()."
    );
    return _remainDuration;
  } ///上层需保证非空调用

  @override
  DateTime referenceTime() {
    assert(
    _endTime != null,
    "You must start CountdownTimer before calling showTime()."
    );
    return _endTime!;
  } ///上层需保证非空调用

  @override
  void start(DateTime now) {
    _endTime = now.add(_remainDuration);
  }

  @override
  void stop(DateTime now) {
    assert(
    _endTime != null,
    "You must start CountdownTimer before calling stop()."
    );
    _remainDuration = _endTime!.difference(now);
  } ///上层需保证非空调用

  void reset(Duration time) {
    _remainDuration = time;
    _endTime = null;
  }

  @override
  bool get isCountup => false;
  @override
  bool get isCountdown => true;

  set remainDuration(Duration duration) {
    _remainDuration = duration;
  }

  set endTime(DateTime time) {
    _endTime = time;
  }
}
