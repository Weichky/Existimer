enum TaskType {
  timer,
  note;

  static TaskType? fromString(String? string) {
    if (string == null) return null;
    switch (string) {
      case 'timer':
        return TaskType.timer;
      case 'note':
        return TaskType.note;
      default:
        throw ArgumentError('Unknown TaskType string: $string');
    }
  }
}