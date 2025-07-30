enum TimerUnitStatus {
  active,
  inactive,
  paused,
  timeout;

  bool get isActive => this == TimerUnitStatus.active;
  bool get isInactive => this == TimerUnitStatus.inactive;
  bool get isPaused => this == TimerUnitStatus.paused;
  bool get isTimeout => this == TimerUnitStatus.timeout;
  
  static TimerUnitStatus fromString(String string) {
    switch (string) {
      case "active":
        return TimerUnitStatus.active;
      case "inactive":
        return TimerUnitStatus.inactive;
      case "paused":
        return TimerUnitStatus.paused;
      case "timeout":
        return TimerUnitStatus.timeout;
      default:
        throw ArgumentError("Bad Argument. Unknown String $string");
    }
  }
}
