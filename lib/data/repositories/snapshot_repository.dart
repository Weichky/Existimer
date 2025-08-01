import 'package:existimer/data/snapshots/snapshot_base.dart';

abstract class SnapshotRepository<T extends SnapshotBase> {
  Future<void> saveSnapshot(T snapshot);
  Future<T?> queryByUuid(String uuid);

  List<String> get validFields;

  bool isValidField(String field) => validFields.contains(field);
}
