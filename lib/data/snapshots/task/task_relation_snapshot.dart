import 'package:existimer/data/snapshots/snapshot_base.dart';
import 'package:existimer/core/constants/database_const.dart';

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
      DatabaseTables.taskRelation.fromUuid.name: fromUuid,
      DatabaseTables.taskRelation.toUuid.name: toUuid,
      DatabaseTables.taskRelation.weight.name: weight,
      DatabaseTables.taskRelation.isManuallyLinked.name: isManuallyLinked ? 1 : 0,
      DatabaseTables.taskRelation.description.name: description,
    };
  }

  static TaskRelationSnapshot fromMap(Map<String, dynamic> map) {
    return TaskRelationSnapshot(
      fromUuid: map[DatabaseTables.taskRelation.fromUuid.name],
      toUuid: map[DatabaseTables.taskRelation.toUuid.name],
      weight: map[DatabaseTables.taskRelation.weight.name] is int ? (map[DatabaseTables.taskRelation.weight.name] as int).toDouble() : map[DatabaseTables.taskRelation.weight.name],
      isManuallyLinked: map[DatabaseTables.taskRelation.isManuallyLinked.name] == 1,
      description: map[DatabaseTables.taskRelation.description.name],
    );
  }
}