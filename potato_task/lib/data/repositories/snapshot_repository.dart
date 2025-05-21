import 'package:existimer/snapshots/snapshot_base.dart';

abstract class SnapshotRepository<T extends SnapshotBase> {
  Future<void> saveSnapshot(T snapshot);
  Future<T?> loadSnapshot(String uuid);
}
