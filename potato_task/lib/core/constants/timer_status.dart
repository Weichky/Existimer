enum TimerStatus{
  inactive,
  active,
  paused;

  bool get isActive => this == TimerStatus.active;
  bool get isInactive => this == TimerStatus.inactive;
  bool get isPaused => this == TimerStatus.paused;
}