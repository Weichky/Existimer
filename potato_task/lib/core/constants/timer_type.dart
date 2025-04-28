enum TimerType {
  forward,
  countdown;

  bool get isForward => this == TimerType.forward;
  bool get isCountdown => this == TimerType.countdown;

  static TimerType fromString(String string) {
    switch (string) {
      case "forward":
        return TimerType.forward;
      case "countdown":
        return TimerType.countdown;
      default:
        throw ArgumentError("Bad Argument. Unknown String $string");
    }
  }
}