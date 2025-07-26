import 'package:existimer/snapshots/snapshot_base.dart';

class TaskRelationSnapshot extends SnapshotBase {
  final String fromUuid;
  final String toUuid;
  final double? weight;
  final bool isManuallyLinked;
  final String? description;

  TaskRelationSnapshot({
    required this.fromUuid,
    required this.toUuid,
    this.weight,
    required this.isManuallyLinked,
    this.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'from_uuid': fromUuid,
      'to_uuid': toUuid,
      'weight': weight,
      'is_manually_linked': isManuallyLinked ? 1 : 0,
      'description': description,
    };
  }

  static TaskRelationSnapshot fromMap(Map<String, dynamic> map) {
    return TaskRelationSnapshot(
      fromUuid: map['from_uuid'],
      toUuid: map['to_uuid'],
      weight: map['weight'] is int ? (map['weight'] as int).toDouble() : map['weight'],
      isManuallyLinked: map['is_manually_linked'] == 1,
      description: map['description'],
    );
  }
}