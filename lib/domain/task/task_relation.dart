class TaskRelation {
  String _fromUuid;
  String _toUuid;
  double? _weight;

  bool _isManuallyLinked;

  String? _description;

  TaskRelation({
    required String fromUuid,
    required String toUUid,
    double? weight,
    required bool isManuallyLinked,
    String? description,
  }) : _fromUuid = fromUuid,
       _toUuid = toUUid,
       // 此处不约束 isManuallyLinked 和 weight 的值
       _weight = weight,
       _isManuallyLinked = isManuallyLinked,
       _description = description {
    // 此处断言
    assert(
      !_isManuallyLinked || _weight == null || _weight == 1.0,
      'Manually linked relation should have weight == 1.0 if set');
  }
}
