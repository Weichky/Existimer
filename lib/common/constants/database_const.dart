// 定义了数据库版本和数据库表，和数据库表字段

// 数据库版本号
// 100 * major + minor
const int databaseVersion = 100;

// Changelog:
// 100 -v1.0.0 初始版本，包括表timer_units、task_meta、history、settings

/// 表tasks
/// order_index字段自增默认间隔
const int orderIndexGap = 1000;

/// 可调整order_index的最小间隔
const int gapThreshold = 1;

/// 调整临近范围
const int orderIndexAdjustRange = 1000;

/// 调整后最小间隔
const int orderIndexAdjustMinGap = 100;

/// 查询关系枚举
/// 用于数据库查询的关系操作符
enum QueryRelation {
  equal, // =
  notEqual, // !=
  lessThan, // <
  lessEqual, // <=
  greaterThan, // >
  greaterEqual, // >=
  like, // LIKE
  any; // ANY

  String? get operator {
    switch (this) {
      case QueryRelation.equal:
        return '=';
      case QueryRelation.notEqual:
        return '!=';
      case QueryRelation.lessThan:
        return '<';
      case QueryRelation.lessEqual:
        return '<=';
      case QueryRelation.greaterThan:
        return '>';
      case QueryRelation.greaterEqual:
        return '>=';
      case QueryRelation.like:
        return 'LIKE';
      case QueryRelation.any:
        return null;
    }
  }
}

/// 数据库表枚举
abstract class DatabaseTables {
  /// timer_units表
  static TimerUnitsTable get timerUnits => TimerUnitsTable();

  /// history表
  static HistoryTable get history => HistoryTable();

  /// tasks表
  static TasksTable get tasks => TasksTable();

  /// task_meta表
  static TaskMetaTable get taskMeta => TaskMetaTable();

  /// task_mapping表
  static TaskMappingTable get taskMapping => TaskMappingTable();

  /// task_relation表
  static TaskRelationTable get taskRelation => TaskRelationTable();

  /// settings表
  static SettingsTable get settings => SettingsTable();
}

/// timer_units表字段定义
class TimerUnitsTable {
  String get name => 'timer_units';
  TimerUnitsFields get uuid => TimerUnitsFields.uuid;
  TimerUnitsFields get status => TimerUnitsFields.status;
  TimerUnitsFields get type => TimerUnitsFields.type;
  TimerUnitsFields get durationMs => TimerUnitsFields.durationMs;
  TimerUnitsFields get referenceTime => TimerUnitsFields.referenceTime;
  TimerUnitsFields get lastRemainMs => TimerUnitsFields.lastRemainMs;
}

/// timer_units表字段枚举
enum TimerUnitsFields {
  uuid,
  status,
  type,
  durationMs,
  referenceTime,
  lastRemainMs;

  String get name {
    switch (this) {
      case uuid:
        return 'uuid';
      case status:
        return 'status';
      case type:
        return 'type';
      case durationMs:
        return 'duration_ms';
      case referenceTime:
        return 'reference_time';
      case lastRemainMs:
        return 'last_remain_ms';
    }
  }
}

/// history表字段定义
class HistoryTable {
  String get name => 'history';
  HistoryFields get historyUuid => HistoryFields.historyUuid;
  HistoryFields get taskUuid => HistoryFields.taskUuid;
  HistoryFields get startedAt => HistoryFields.startedAt;
  HistoryFields get sessionDurationMs => HistoryFields.sessionDurationMs;
  HistoryFields get count => HistoryFields.count;
  HistoryFields get isArchived => HistoryFields.isArchived;
}

/// history表字段枚举
enum HistoryFields {
  historyUuid,
  taskUuid,
  startedAt,
  sessionDurationMs,
  count,
  isArchived;

  String get name {
    switch (this) {
      case historyUuid:
        return 'history_uuid';
      case taskUuid:
        return 'task_uuid';
      case startedAt:
        return 'started_at';
      case sessionDurationMs:
        return 'session_duration_ms';
      case count:
        return 'count';
      case isArchived:
        return 'is_archived';
    }
  }
}

/// tasks表字段定义
class TasksTable {
  String get name => 'tasks';
  TasksFields get uuid => TasksFields.uuid;
  TasksFields get nameField => TasksFields.nameField;
  TasksFields get type => TasksFields.type;
  TasksFields get createdAt => TasksFields.createdAt;
  TasksFields get lastUsedAt => TasksFields.lastUsedAt;
  TasksFields get isArchived => TasksFields.isArchived;
  TasksFields get isHighlighted => TasksFields.isHighlighted;
  TasksFields get color => TasksFields.color;
  TasksFields get opacity => TasksFields.opacity;
  TasksFields get orderIndex => TasksFields.orderIndex;
}

/// tasks表字段枚举
enum TasksFields {
  uuid,
  nameField,
  type,
  createdAt,
  lastUsedAt,
  isArchived,
  isHighlighted,
  color,
  opacity,
  orderIndex;

  String get name {
    switch (this) {
      case uuid:
        return 'uuid';
      case nameField:
        return 'name';
      case type:
        return 'type';
      case createdAt:
        return 'created_at';
      case lastUsedAt:
        return 'last_used_at';
      case isArchived:
        return 'is_archived';
      case isHighlighted:
        return 'is_highlighted';
      case color:
        return 'color';
      case opacity:
        return 'opacity';
      case orderIndex:
        return 'order_index';
    }
  }
}

/// task_meta表字段定义
class TaskMetaTable {
  String get name => 'task_meta';
  TaskMetaFields get taskUuid => TaskMetaFields.taskUuid;
  TaskMetaFields get createdAt => TaskMetaFields.createdAt;
  TaskMetaFields get firstUsedAt => TaskMetaFields.firstUsedAt;
  TaskMetaFields get lastUsedAt => TaskMetaFields.lastUsedAt;
  TaskMetaFields get totalUsedCount => TaskMetaFields.totalUsedCount;
  TaskMetaFields get totalCount => TaskMetaFields.totalCount;
  TaskMetaFields get avgSessionDurationMs =>
      TaskMetaFields.avgSessionDurationMs;
  TaskMetaFields get icon => TaskMetaFields.icon;
  TaskMetaFields get baseColor => TaskMetaFields.baseColor;
}

/// task_meta表字段枚举
enum TaskMetaFields {
  taskUuid,
  createdAt,
  firstUsedAt,
  lastUsedAt,
  totalUsedCount,
  totalCount,
  avgSessionDurationMs,
  icon,
  baseColor;

  String get name {
    switch (this) {
      case taskUuid:
        return 'task_uuid';
      case createdAt:
        return 'created_at';
      case firstUsedAt:
        return 'first_used_at';
      case lastUsedAt:
        return 'last_used_at';
      case totalUsedCount:
        return 'total_used_count';
      case totalCount:
        return 'total_count';
      case avgSessionDurationMs:
        return 'avg_session_duration_ms';
      case icon:
        return 'icon';
      case baseColor:
        return 'base_color';
    }
  }
}

/// task_mapping表字段定义
class TaskMappingTable {
  String get name => 'task_mapping';
  TaskMappingFields get taskUuid => TaskMappingFields.taskUuid;
  TaskMappingFields get entityUuid => TaskMappingFields.entityUuid;
  TaskMappingFields get entityType => TaskMappingFields.entityType;
}

/// task_mapping表字段枚举
enum TaskMappingFields {
  taskUuid,
  entityUuid,
  entityType;

  String get name {
    switch (this) {
      case taskUuid:
        return 'task_uuid';
      case entityUuid:
        return 'entity_uuid';
      case entityType:
        return 'entity_type';
    }
  }
}

/// task_relation表字段定义
class TaskRelationTable {
  String get name => 'task_relation';
  TaskRelationFields get fromUuid => TaskRelationFields.fromUuid;
  TaskRelationFields get toUuid => TaskRelationFields.toUuid;
  TaskRelationFields get weight => TaskRelationFields.weight;
  TaskRelationFields get isManuallyLinked =>
      TaskRelationFields.isManuallyLinked;
  TaskRelationFields get description => TaskRelationFields.description;
}

/// task_relation表字段枚举
enum TaskRelationFields {
  fromUuid,
  toUuid,
  weight,
  isManuallyLinked,
  description;

  String get name {
    switch (this) {
      case fromUuid:
        return 'from_uuid';
      case toUuid:
        return 'to_uuid';
      case weight:
        return 'weight';
      case isManuallyLinked:
        return 'is_manually_linked';
      case description:
        return 'description';
    }
  }
}

/// settings表字段定义
class SettingsTable {
  String get name => 'settings';
  SettingsFields get id => SettingsFields.id;
  SettingsFields get json => SettingsFields.json;
}

/// settings表字段枚举
enum SettingsFields {
  id,
  json;

  String get name {
    switch (this) {
      case id:
        return 'id';
      case json:
        return 'json';
    }
  }
}
