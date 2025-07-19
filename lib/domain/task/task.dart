import 'package:existimer/snapshots/task_snapshot.dart';

class TaskMeta {
  String _uuid;
  String _name;
  String _type;
  DateTime _createAt;
  DateTime? _lastUsedAt;
  bool _isArchived;
  bool _isHighlighted;
  String? _color;
  String? _description;

  TaskMeta({
    required String uuid,
    required String name,
    required String type,
    required DateTime createAt,
    DateTime? lastUsedAt,
    bool? isArchived,
    bool? isHighlighted,
    String? color,
    String? description,
  }) : _uuid = uuid,
       _name = name,
       _type = type,
       _createAt = createAt,
       _lastUsedAt = lastUsedAt,
       _isArchived = isArchived ?? false,
       _isHighlighted = isHighlighted ?? false,
       _color = color,
       _description = description;

  // setter
  set uuid(String uuid) {
    _uuid = uuid;
  }

  set name(String name) {
    _name = name;
  }

  set type(String type) {
    _type = type;
  }

  set createAt(DateTime createAt) {
    _createAt = createAt;
  }

  set lastUsedAt(DateTime? lastUsedAt) {
    _lastUsedAt = lastUsedAt;
  }

  set isArchived(bool isArchived) {
    _isArchived = isArchived;
  }

  set isHighlighted(bool isHighlighted) {
    _isHighlighted = isHighlighted;
  }

  set color(String? color) {
    _color = color;
  }

  set description(String? description) {
    _description = description;
  }

  TaskSnapshot toSnapshot() => TaskSnapshot(
    uuid: _uuid,
    name: _name,
    type: _type,
    createAt: _createAt,
    lastUsedAt: _lastUsedAt,
    isArchived: _isArchived,
    isHighlighted: _isHighlighted,
    color: _color,
    description: _description,
  );

  void fromSnapshot(TaskSnapshot taskSnapshot) {
    _uuid = taskSnapshot.uuid;
    _name = taskSnapshot.name;
    _type = taskSnapshot.type;
    _createAt = taskSnapshot.createAt;
    _lastUsedAt = taskSnapshot.lastUsedAt;
    _isArchived = taskSnapshot.isArchived;
    _isHighlighted = taskSnapshot.isHighlighted;
    _color = taskSnapshot.color;
    _description = taskSnapshot.description;
  }
}
