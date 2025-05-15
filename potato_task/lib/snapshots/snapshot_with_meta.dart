import 'package:potato_task/snapshots/snapshot_base.dart';
import 'package:potato_task/snapshots/task_meta_snapshot.dart';

class SnapshotWithMeta<T extends SnapshotBase> extends SnapshotBase {
  final T snapshot;
  final TaskMetaSnapshot taskMetaSnapshot;

  SnapshotWithMeta({
    required this.snapshot,
    required this.taskMetaSnapshot,
  });

  @override
Map<String, dynamic> toMap() {
    return {
      ...taskMetaSnapshot.toMap(),
      ...snapshot.toMap(),
    };
  }
}