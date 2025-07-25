import 'package:flutter/material.dart';

class TaskMeta {
  String _taskUuid;

  DateTime _createAt;
  DateTime? _firstUsedAt;
  DateTime? _lastUsedAt;

  int _totalUsedCount;
  Duration? _avgSessionLength;

  String? _icon;

  String? _baseColor;

  String? _description;
}
