import 'package:existimer/snapshots/snapshot_base.dart';


class TaskSnapshot extends SnapshotBase {
  final String uuid;
  final String name;
  final String type;
  final DateTime createAt;
  final DateTime? lastUsedAt;
  final bool isArchived;
  final bool isHighlighted;
  final String? color;
  final String? description;

  TaskSnapshot({
    required this.uuid,
    required this.name,
    required this.type,
    required this.createAt,
    this.lastUsedAt,
    required this.isArchived,    
    required this.isHighlighted,
    this.color,
    this.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'type': type,
      'create_at': createAt.toIso8601String(),
      'description': description,
      'is_archived': isArchived,
    };
  }

  static TaskSnapshot fromMap(Map<String, dynamic> map) {
    return TaskSnapshot(
      uuid: map['uuid'],
      name: map['name'],
      type: map['type'],
      createAt: DateTime.parse(map['create_at']),
      lastUsedAt: DateTime.parse(map['last_used_at']),
      isArchived: map['is_archived'],
      isHighlighted: map['is_highlighted'],
      color: map['color'],
      description: map['description'],
    );
  }
}