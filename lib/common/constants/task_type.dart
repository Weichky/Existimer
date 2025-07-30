enum TaskType {
  timer,
  note;

  static TaskType fromString(String? string) {
    if (string == null) {
      throw ArgumentError("Bad Argument. String cannot be NULL.");
    }
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