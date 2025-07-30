import 'package:existimer/common/utils/helper.dart';
import 'package:existimer/data/snapshots/task/task_relation_snapshot.dart';

class TaskRelation {
  String _fromUuid;
  String _toUuid;
  double? _weight;

  bool _isManuallyLinked;

  String? _description;

  TaskRelation({
    required String fromUuid,
    required String toUuid,
    double? weight,
    required bool isManuallyLinked,
    String? description,
  }) : _fromUuid = fromUuid,
       _toUuid = toUuid,
       // 此处不约束 isManuallyLinked 和 weight 的值
       _weight = weight,
       _isManuallyLinked = isManuallyLinked,
       _description = description {
    // 此处断言
    assert(
      !_isManuallyLinked || _weight == null || _weight == 1.0,
      'Manually linked relation should have weight == 1.0 if set');
  }
  
  // getter
  String get fromUuid => _fromUuid;
  String get toUuid => _toUuid;
  double? get weight => _weight;
  bool get isManuallyLinked => _isManuallyLinked;
  String? get description => _description;
  
  TaskRelationSnapshot toSnapshot() => TaskRelationSnapshot(
    fromUuid: _fromUuid,
    toUuid: _toUuid,
    weight: _weight,
    isManuallyLinked: _isManuallyLinked,
    description: _description,
  );
  
  factory TaskRelation.fromSnapshot(TaskRelationSnapshot snapshot) {
    return TaskRelation(
      fromUuid: snapshot.fromUuid,
      toUuid: snapshot.toUuid,
      weight: snapshot.weight,
      isManuallyLinked: snapshot.isManuallyLinked,
      description: snapshot.description,
    );
  }
}