class TaskMetaSnapshot {
  final String uuid;
  final String name;
  final String type;
  final DateTime createAt;
  final String? description;
  final bool archived;

  TaskMetaSnapshot({
    required this.uuid,
    required this.name,
    required this.type,
    required this.createAt,
    this.description,
    required this.archived,
  });

  static TaskMetaSnapshot fromMap(Map<String, dynamic> map) {
    return TaskMetaSnapshot(
      uuid: map['uuid'],
      name: map['name'],
      type: map['type'],
      createAt: DateTime.parse(map['create_at']),
      description: map['description'],
      archived: map['archived'],
    );
  }
}

extension TaskMetaSnapshotStorage on TaskMetaSnapshot {
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
}