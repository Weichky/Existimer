import 'package:potato_task/snapshots/task_meta_snapshot.dart';

class TaskMeta {
  String _uuid;
  String _name;
  String _type;
  DateTime _createAt;
  String? _description;
  bool _archived;

  TaskMeta({
    required String uuid,
    required String name,
    required String type,
    required DateTime createAt,
    String? description,
    required bool archived,
  }) : _uuid = uuid,
       _name = name,
       _type = type,
       _createAt = createAt,
       _description = description,
       _archived = archived;

  // setter
  set name(String name) {
    _name = name;
  }

  set type(String type) {
    _type = type;
  }

  set description(String? description) {
    _description = description;
  }

  set archived(bool archived) {
    _archived =archived;
  }

  TaskMetaSnapshot toSnapshot() => TaskMetaSnapshot(
    uuid: _uuid,
    name: _name,
    type: _type,
    createAt: _createAt,
    description: _description,
    archived: _archived,
  );

  void fromSnapshot(TaskMetaSnapshot taskMetaSnapshot) {
    _uuid = taskMetaSnapshot.uuid;
    _name = taskMetaSnapshot.name;
    _type = taskMetaSnapshot.type;
    _createAt = taskMetaSnapshot.createAt;
    _description = taskMetaSnapshot.description;
    _archived = taskMetaSnapshot.archived;
  }
}
