enum TimerUnitStatus{
  active,
  inactive,  
  paused,
  timeout;

  bool get isActive => this == TimerUnitStatus.active;
  bool get isInactive => this == TimerUnitStatus.inactive;
  bool get isPaused => this == TimerUnitStatus.paused;
  bool get isTimeout => this == TimerUnitStatus.timeout;
}