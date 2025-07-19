import 'package:existimer/snapshots/snapshot_base.dart';


class TaskSnapshot extends SnapshotBase {
  final String uuid;
  final String name;
  final String type;
  final DateTime createAt;
  final String? description;
  final bool archived;

  TaskSnapshot({
    required this.uuid,
    required this.name,
    required this.type,
    required this.createAt,
    this.description,
    required this.archived,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'type': type,
      'create_at': createAt.toIso8601String(),
      'description': description,
      'archived': archived,
    };
  }

  static TaskSnapshot fromMap(Map<String, dynamic> map) {
    return TaskSnapshot(
      uuid: map['uuid'],
      name: map['name'],
      type: map['type'],
      createAt: DateTime.parse(map['create_at']),
      description: map['description'],
      archived: map['archived'],
    );
  }
}