enum TimerUnitType {
  countup,
  countdown;

  bool get isCountup => this == TimerUnitType.countup;
  bool get isCountdown => this == TimerUnitType.countdown;

  String get name {
    switch (this) {
      case TimerUnitType.countup:
        return "countup";
      case TimerUnitType.countdown:
        return "countdown";
    }
  }

  static TimerUnitType fromString(String string) {
    switch (string) {
      case "Countup":
        return TimerUnitType.countup;
      case "countdown":
        return TimerUnitType.countdown;
      default:
        throw ArgumentError("Bad Argument. Unknown String $string");
    }
  }
}
