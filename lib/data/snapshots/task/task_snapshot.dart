// task_snapshot.dart

import 'package:existimer/common/constants/task_type.dart';
import 'package:existimer/data/snapshots/snapshot_base.dart';
import 'package:existimer/common/constants/database_const.dart';

class TaskSnapshot extends SnapshotBase {
  final String uuid;
  final String? name;
  final TaskType type;

  final DateTime createdAt;
  final DateTime? lastUsedAt;

  final bool isArchived;
  final bool isHighlighted;

  final String? color;
  final double opacity;

  TaskSnapshot({
    required this.uuid,
    this.name,
    required this.type,
    required this.createdAt,
    this.lastUsedAt,
    required this.isArchived,
    required this.isHighlighted,
    this.color,
    required this.opacity,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      DatabaseTables.tasks.uuid.name: uuid,
      DatabaseTables.tasks.nameField.name: name,
      DatabaseTables.tasks.type.name: type.name,
      DatabaseTables.tasks.createdAt.name: createdAt.millisecondsSinceEpoch,
      DatabaseTables.tasks.lastUsedAt.name: lastUsedAt?.millisecondsSinceEpoch,
      DatabaseTables.tasks.isArchived.name: isArchived ? 1 : 0,  // 将布尔值转换为整数存储
      DatabaseTables.tasks.isHighlighted.name: isHighlighted ? 1 : 0,  // 将布尔值转换为整数存储
      DatabaseTables.tasks.color.name: color,
      DatabaseTables.tasks.opacity.name: opacity,
    };
  }

  static TaskSnapshot fromMap(Map<String, dynamic> map) {
    return TaskSnapshot(
      uuid: map[DatabaseTables.tasks.uuid.name],
      name: map[DatabaseTables.tasks.nameField.name],
      type: TaskType.fromString(map[DatabaseTables.tasks.type.name]),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map[DatabaseTables.tasks.createdAt.name]),
      lastUsedAt:
          map[DatabaseTables.tasks.lastUsedAt.name] != null
              ? DateTime.fromMillisecondsSinceEpoch(map[DatabaseTables.tasks.lastUsedAt.name])
              : null,
      isArchived: map[DatabaseTables.tasks.isArchived.name] == 1, // 若是 SQLite 中的整数值
      isHighlighted: map[DatabaseTables.tasks.isHighlighted.name] == 1,
      color: map[DatabaseTables.tasks.color.name],
      opacity: (map[DatabaseTables.tasks.opacity.name] as num).toDouble(),
    );
  }
}