enum TimerUnitType {
  countup,
  countdown;

  bool get isCountup => this == TimerUnitType.countup;
  bool get isCountdown => this == TimerUnitType.countdown;

  static TimerUnitType fromString(String? string) {
    if (string == null) {
      throw ArgumentError("Bad Argument. String cannot be NULL.");
    }
    switch (string) {
      case "countup":
        return TimerUnitType.countup;
      case "countdown":
        return TimerUnitType.countdown;
      default:
        throw ArgumentError("Bad Argument. Unknown String $string");
    }
  }
}
