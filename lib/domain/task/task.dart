// task.dart

import 'package:existimer/core/utils/clock.dart';
import 'package:existimer/snapshots/task/task_snapshot.dart';
import 'package:existimer/core/utils/helper.dart';
import 'package:existimer/core/constants/task_type.dart';

class Task {
  String _uuid;
  String? _name;
  TaskType _type;

  DateTime _createdAt;// 保留字段，方便查找
  DateTime? _lastUsedAt;// 保留字段，方便查找

  bool _isArchived;
  bool _isHighlighted;

  String? _color;
  double _opacity;

  Task({
    String? name,
    required TaskType type,
    required DateTime createdAt,
    DateTime? lastUsedAt,
    bool? isArchived,
    bool? isHighlighted,
    String? color,
    required double opacity,
  }) : _uuid = UuidHelper.getUuid(),
       _name = name,
       _type = type,
       _createdAt = createdAt,
       _lastUsedAt = lastUsedAt,
       _isArchived = isArchived ?? false,
       _isHighlighted = isHighlighted ?? false,
       _color = color,
       _opacity = opacity;

  factory Task.fromSnapshot(TaskSnapshot snapshot) {
    Task task = Task(
      type: TaskType.timer,
      createdAt: Clock.instance.currentTime,
      opacity: 0.0,
    );

    task.fromSnapshot(snapshot);

    return task;
  }

  // setter
  set setName(String name) {
    _name = name;
  }

  set setType(TaskType type) {
    _type = type;
  }

  set setIsArchived(bool isArchived) {
    _isArchived = isArchived;
  }

  set setIsHighlighted(bool isHighlighted) {
    _isHighlighted = isHighlighted;
  }

  set setColor(String? color) {
    _color = color;
  }

  set setOpacity(double opacity) {
    _opacity = opacity;
  }

  // getter
  String get uuid => _uuid;

  String? get name => _name;

  TaskType get type => _type;

  DateTime get createdAt => _createdAt;

  DateTime? get lastUsedAt => _lastUsedAt;

  bool get isArchived => _isArchived;

  bool get isHighlighted => _isHighlighted;

  String? get color => _color;

  double get opacity => _opacity;

  TaskSnapshot toSnapshot() => TaskSnapshot(
    uuid: _uuid,
    name: _name,
    type: _type,
    createdAt: _createdAt,
    lastUsedAt: _lastUsedAt,
    isArchived: _isArchived,
    isHighlighted: _isHighlighted,
    color: _color,
    opacity: _opacity,
  );

  void fromSnapshot(TaskSnapshot taskSnapshot) {
    _uuid = taskSnapshot.uuid;
    _name = taskSnapshot.name;
    _type = taskSnapshot.type;
    _createdAt = taskSnapshot.createdAt;
    _lastUsedAt = taskSnapshot.lastUsedAt;
    _isArchived = taskSnapshot.isArchived;
    _isHighlighted = taskSnapshot.isHighlighted;
    _color = taskSnapshot.color;
    _opacity = taskSnapshot.opacity;
  }
}
