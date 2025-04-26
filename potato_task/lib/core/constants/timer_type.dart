enum TimerType {
  forward,
  countdown;

  bool get isForward => this == TimerType.forward;
  bool get isCountdown => this == TimerType.countdown;
}