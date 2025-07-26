// task_snapshot.dart

import 'package:existimer/core/constants/task_type.dart';
import 'package:existimer/snapshots/snapshot_base.dart';

class TaskSnapshot extends SnapshotBase {
  final String uuid;
  final String? name;
  final TaskType type;

  final DateTime createAt;
  final DateTime? lastUsedAt;

  final bool isArchived;
  final bool isHighlighted;

  final String? color;
  final double opacity;

  TaskSnapshot({
    required this.uuid,
    this.name,
    required this.type,
    required this.createAt,
    this.lastUsedAt,
    required this.isArchived,
    required this.isHighlighted,
    this.color,
    required this.opacity,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'type': type.name,
      'create_at': createAt.millisecondsSinceEpoch,
      'last_used_at': lastUsedAt?.millisecondsSinceEpoch,
      'is_archived': isArchived,
      'is_highlighted': isHighlighted,
      'color': color,
      'opacity': opacity,
    };
  }

  static TaskSnapshot fromMap(Map<String, dynamic> map) {
    return TaskSnapshot(
      uuid: map['uuid'],
      name: map['name'],
      type: TaskType.fromString(map['type']),
      createAt: DateTime.fromMillisecondsSinceEpoch(map['create_at']),
      lastUsedAt: DateTime.fromMillisecondsSinceEpoch(map['last_used_at']),
      isArchived: map['is_archived'],
      isHighlighted: map['is_highlighted'],
      color: map['color'],
      opacity: map['opacity'],
    );
  }
}
