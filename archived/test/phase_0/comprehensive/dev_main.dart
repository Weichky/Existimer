import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:existimer/application/services/app_startup_service.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/domain/task/task.dart';
import 'package:existimer/domain/task/task_mapping.dart';
import 'package:existimer/domain/task/task_meta.dart';
import 'package:existimer/domain/task/task_relation.dart';
import 'package:existimer/domain/history/history.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/common/constants/task_type.dart';
import 'package:existimer/common/utils/clock.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final AppDatabase appDatabase = AppDatabase();
  await appDatabase.init();

  final AppStartupService appStartupService = AppStartupService(
    database: appDatabase
  );

  await appStartupService.initializeApp();

  print('开始综合测试...');

  /// 测试Task的CRUD操作
  await testTaskCRUD(appStartupService);
  
  /// 测试TimerUnit的CRUD操作
  await testTimerUnitCRUD(appStartupService);
  
  /// 测试TaskMapping的CRUD操作
  await testTaskMappingCRUD(appStartupService);
  
  /// 测试TaskMeta的CRUD操作
  await testTaskMetaCRUD(appStartupService);
  
  /// 测试TaskRelation的CRUD操作
  await testTaskRelationCRUD(appStartupService);
  
  /// 测试History的CRUD操作
  await testHistoryCRUD(appStartupService);

  print('综合测试完成！');
}

Future<void> testTaskMetaCRUD(AppStartupService appStartupService) async {
  print('\n=== 测试TaskMeta CRUD操作 ===');
  
  final taskMetaRepo = appStartupService.taskMetaRepo;
  
  /// 创建一个Task
  final task = Task(
    name: '测试任务',
    type: TaskType.timer,
    createdAt: Clock.instance.currentTime,
    opacity: 0.8,
  );
  
  /// 先保存Task
  await appStartupService.taskRepo.saveSnapshot(task.toSnapshot());
  
  /// 创建TaskMeta
  final taskMeta = TaskMeta(
    taskUuid: task.uuid,
    createAt: Clock.instance.currentTime,
    totalUsedCount: 0,
  );
  
  print('1. 创建TaskMeta:');
  print('   Task UUID: ${taskMeta.toSnapshot().taskUuid}');
  print('   Created At: ${taskMeta.toSnapshot().createdAt}');
  print('   Total Used Count: ${taskMeta.toSnapshot().totalUsedCount}');
  
  /// 保存到数据库
  final snapshot = taskMeta.toSnapshot();
  await taskMetaRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  /// 查询TaskMeta
  final snapshots = await taskMetaRepo.queryByField('task_uuid', task.uuid);
  if (snapshots.isNotEmpty) {
    final loadedTaskMeta = TaskMeta.fromSnapshot(snapshots.first);
    print('2. 查询TaskMeta:');
    print('   Task UUID: ${loadedTaskMeta.toSnapshot().taskUuid}');
    print('   Created At: ${loadedTaskMeta.toSnapshot().createdAt}');
    print('   Total Used Count: ${loadedTaskMeta.toSnapshot().totalUsedCount}');
  } else {
    print('   查询失败：未找到TaskMeta');
  }
  
  /// 更新TaskMeta
  taskMeta.setFirstUsedAt = Clock.instance.currentTime;
  taskMeta.setBaseColor = '#FF0000';
  await taskMetaRepo.saveSnapshot(taskMeta.toSnapshot());
  print('3. 更新TaskMeta:');
  print('   First Used At更新为: ${taskMeta.toSnapshot().firstUsedAt}');
  print('   Base Color更新为: ${taskMeta.toSnapshot().baseColor}');
  
  /// 再次查询验证更新
  final updatedSnapshots = await taskMetaRepo.queryByField('task_uuid', task.uuid);
  if (updatedSnapshots.isNotEmpty) {
    final updatedTaskMeta = TaskMeta.fromSnapshot(updatedSnapshots.first);
    print('4. 验证更新:');
    print('   First Used At: ${updatedTaskMeta.toSnapshot().firstUsedAt}');
    print('   Base Color: ${updatedTaskMeta.toSnapshot().baseColor}');
  }
  
  /// 删除TaskMeta
  await taskMetaRepo.deleteByField('task_uuid', task.uuid);
  print('5. 删除TaskMeta');
  
  /// 删除关联的Task
  await appStartupService.taskRepo.deleteByField('uuid', task.uuid);
  
  /// 验证删除
  final deletedSnapshots = await taskMetaRepo.queryByField('task_uuid', task.uuid);
  print('6. 验证删除:');
  if (deletedSnapshots.isEmpty) {
    print('   TaskMeta已成功删除');
  } else {
    print('   删除失败：TaskMeta仍然存在');
  }
}

Future<void> testTaskRelationCRUD(AppStartupService appStartupService) async {
  print('\n=== 测试TaskRelation CRUD操作 ===');
  
  final taskRelationRepo = appStartupService.taskRelationRepo;
  
  /// 创建两个Task
  final task1 = Task(
    name: '测试任务1',
    type: TaskType.timer,
    createdAt: Clock.instance.currentTime,
    opacity: 0.8,
  );
  
  final task2 = Task(
    name: '测试任务2',
    type: TaskType.timer,
    createdAt: Clock.instance.currentTime,
    opacity: 0.8,
  );
  
  /// 先保存Tasks
  await appStartupService.taskRepo.saveSnapshot(task1.toSnapshot());
  await appStartupService.taskRepo.saveSnapshot(task2.toSnapshot());
  
  /// 创建TaskRelation
  final taskRelation = TaskRelation(
    fromUuid: task1.uuid,
    toUuid: task2.uuid,
    isManuallyLinked: true,
    description: '测试任务关系',
  );
  
  print('1. 创建TaskRelation:');
  print('   From UUID: ${taskRelation.fromUuid}');
  print('   To UUID: ${taskRelation.toUuid}');
  print('   Is Manually Linked: ${taskRelation.isManuallyLinked}');
  print('   Description: ${taskRelation.description}');
  
  /// 保存到数据库
  final snapshot = taskRelation.toSnapshot();
  await taskRelationRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  /// 查询TaskRelation
  final snapshots = await taskRelationRepo.queryByField('from_uuid', task1.uuid);
  if (snapshots.isNotEmpty) {
    final loadedTaskRelation = TaskRelation.fromSnapshot(snapshots.first);
    print('2. 查询TaskRelation:');
    print('   From UUID: ${loadedTaskRelation.fromUuid}');
    print('   To UUID: ${loadedTaskRelation.toUuid}');
    print('   Is Manually Linked: ${loadedTaskRelation.isManuallyLinked}');
    print('   Description: ${loadedTaskRelation.description}');
  } else {
    print('   查询失败：未找到TaskRelation');
  }
  
  /// 更新TaskRelation
  /// 创建一个新的TaskRelation对象（因为字段是只读的，所以需要创建新对象）
  final updatedTaskRelation = TaskRelation(
    fromUuid: task1.uuid,
    toUuid: task2.uuid,
    weight: 0.8,
    isManuallyLinked: false,
    description: '更新后的任务关系',
  );
  await taskRelationRepo.saveSnapshot(updatedTaskRelation.toSnapshot());
  print('3. 更新TaskRelation:');
  print('   Weight更新为: ${updatedTaskRelation.weight}');
  print('   Is Manually Linked更新为: ${updatedTaskRelation.isManuallyLinked}');
  print('   Description更新为: ${updatedTaskRelation.description}');
  
  /// 再次查询验证更新
  final updatedSnapshots = await taskRelationRepo.queryByField('from_uuid', task1.uuid);
  if (updatedSnapshots.isNotEmpty) {
    final updatedTaskRelationLoaded = TaskRelation.fromSnapshot(updatedSnapshots.first);
    print('4. 验证更新:');
    print('   Weight: ${updatedTaskRelationLoaded.weight}');
    print('   Is Manually Linked: ${updatedTaskRelationLoaded.isManuallyLinked}');
    print('   Description: ${updatedTaskRelationLoaded.description}');
  }
  
  /// 删除TaskRelation
  await taskRelationRepo.deleteByField('from_uuid', task1.uuid);
  print('5. 删除TaskRelation');
  
  /// 删除关联的Tasks
  await appStartupService.taskRepo.deleteByField('uuid', task1.uuid);
  await appStartupService.taskRepo.deleteByField('uuid', task2.uuid);
  
  /// 验证删除
  final deletedSnapshots = await taskRelationRepo.queryByField('from_uuid', task1.uuid);
  print('6. 验证删除:');
  if (deletedSnapshots.isEmpty) {
    print('   TaskRelation已成功删除');
  } else {
    print('   删除失败：TaskRelation仍然存在');
  }
}

Future<void> testHistoryCRUD(AppStartupService appStartupService) async {
  print('\n=== 测试History CRUD操作 ===');
  
  final historyRepo = appStartupService.historyRepo;
  
  /// 创建一个Task
  final task = Task(
    name: '测试任务',
    type: TaskType.timer,
    createdAt: Clock.instance.currentTime,
    opacity: 0.8,
  );
  
  /// 先保存Task
  await appStartupService.taskRepo.saveSnapshot(task.toSnapshot());
  
  /// 创建History
  final history = History(
    taskUuid: task.uuid,
    startedAt: Clock.instance.currentTime,
    sessionDuration: Duration(minutes: 25),
    count: 1,
    isArchived: false,
  );
  
  print('1. 创建History:');
  print('   History UUID: ${history.historyUuid}');
  print('   Task UUID: ${history.taskUuid}');
  print('   Started At: ${history.startedAt}');
  print('   Session Duration: ${history.sessionDuration}');
  print('   Count: ${history.count}');
  print('   Is Archived: ${history.isArchived}');
  
  /// 保存到数据库
  final snapshot = history.toSnapshot();
  await historyRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  /// 查询History
  final snapshots = await historyRepo.queryByField('history_uuid', history.historyUuid);
  if (snapshots.isNotEmpty) {
    final loadedHistory = History.fromSnapshot(snapshots.first);
    print('2. 查询History:');
    print('   History UUID: ${loadedHistory.historyUuid}');
    print('   Task UUID: ${loadedHistory.taskUuid}');
    print('   Started At: ${loadedHistory.startedAt}');
    print('   Session Duration: ${loadedHistory.sessionDuration}');
    print('   Count: ${loadedHistory.count}');
    print('   Is Archived: ${loadedHistory.isArchived}');
  } else {
    print('   查询失败：未找到History');
  }
  
  /// 更新History
  history.setSessionDuration = Duration(minutes: 30);
  history.addToCount(addition: 1);
  await historyRepo.saveSnapshot(history.toSnapshot());
  print('3. 更新History:');
  print('   Session Duration更新为: ${history.sessionDuration}');
  print('   Count更新为: ${history.count}');
  
  /// 再次查询验证更新
  final updatedSnapshots = await historyRepo.queryByField('history_uuid', history.historyUuid);
  if (updatedSnapshots.isNotEmpty) {
    final updatedHistory = History.fromSnapshot(updatedSnapshots.first);
    print('4. 验证更新:');
    print('   Session Duration: ${updatedHistory.sessionDuration}');
    print('   Count: ${updatedHistory.count}');
  }
  
  /// 删除History
  await historyRepo.deleteByField('history_uuid', history.historyUuid);
  print('5. 删除History');
  
  /// 删除关联的Task
  await appStartupService.taskRepo.deleteByField('uuid', task.uuid);
  
  /// 验证删除
  final deletedSnapshots = await historyRepo.queryByField('history_uuid', history.historyUuid);
  print('6. 验证删除:');
  if (deletedSnapshots.isEmpty) {
    print('   History已成功删除');
  } else {
    print('   删除失败：History仍然存在');
  }
}

Future<void> testTaskCRUD(AppStartupService appStartupService) async {
  print('\n=== 测试Task CRUD操作 ===');
  
  final taskRepo = appStartupService.taskRepo;
  
  /// 创建一个Task
  final task = Task(
    name: '测试任务',
    type: TaskType.timer,
    createdAt: Clock.instance.currentTime,
    opacity: 0.8,
  );
  
  print('1. 创建Task:');
  print('   UUID: ${task.uuid}');
  print('   Name: ${task.name}');
  print('   Type: ${task.type}');
  
  /// 保存到数据库
  final snapshot = task.toSnapshot();
  await taskRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  /// 查询Task
  final snapshots = await taskRepo.queryByField('uuid', task.uuid);
  if (snapshots.isNotEmpty) {
    final loadedTask = Task.fromSnapshot(snapshots.first);
    print('2. 查询Task:');
    print('   UUID: ${loadedTask.uuid}');
    print('   Name: ${loadedTask.name}');
    print('   Type: ${loadedTask.type}');
  } else {
    print('   查询失败：未找到Task');
  }
  
  /// 更新Task
  task.name = '更新后的任务';
  task.isHighlighted = true;
  await taskRepo.saveSnapshot(task.toSnapshot());
  print('3. 更新Task:');
  print('   Name更新为: ${task.name}');
  print('   IsHighlighted更新为: ${task.isHighlighted}');
  
  /// 再次查询验证更新
  final updatedSnapshots = await taskRepo.queryByField('uuid', task.uuid);
  if (updatedSnapshots.isNotEmpty) {
    final updatedTask = Task.fromSnapshot(updatedSnapshots.first);
    print('4. 验证更新:');
    print('   Name: ${updatedTask.name}');
    print('   IsHighlighted: ${updatedTask.isHighlighted}');
  }
  
  /// 删除Task
  await taskRepo.deleteByField('uuid', task.uuid);
  print('5. 删除Task');
  
  /// 验证删除
  final deletedSnapshots = await taskRepo.queryByField('uuid', task.uuid);
  print('6. 验证删除:');
  if (deletedSnapshots.isEmpty) {
    print('   Task已成功删除');
  } else {
    print('   删除失败：Task仍然存在');
  }
}

Future<void> testTimerUnitCRUD(AppStartupService appStartupService) async {
  print('\n=== 测试TimerUnit CRUD操作 ===');
  
  final timerRepo = appStartupService.timerRepo;
  
  /// 创建一个倒计时TimerUnit
  final timerUnit = TimerUnit.countdown(Duration(minutes: 25));
  
  print('1. 创建TimerUnit:');
  print('   UUID: ${timerUnit.uuid}');
  print('   Type: ${timerUnit.type}');
  print('   Status: ${timerUnit.status}');
  print('   Duration: ${timerUnit.duration}');
  
  /// 保存到数据库
  final snapshot = timerUnit.toSnapshot();
  await timerRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  /// 查询TimerUnit
  final snapshots = await timerRepo.queryByField('uuid', timerUnit.uuid);
  if (snapshots.isNotEmpty) {
    final loadedTimerUnit = TimerUnit.fromSnapshot(snapshots.first);
    print('2. 查询TimerUnit:');
    print('   UUID: ${loadedTimerUnit.uuid}');
    print('   Type: ${loadedTimerUnit.type}');
    print('   Status: ${loadedTimerUnit.status}');
    print('   Duration: ${loadedTimerUnit.duration}');
  } else {
    print('   查询失败：未找到TimerUnit');
  }
  
  /// 更新TimerUnit (启动计时器)
  timerUnit.start();
  await timerRepo.saveSnapshot(timerUnit.toSnapshot());
  print('3. 更新TimerUnit:');
  print('   Status更新为: ${timerUnit.status}');
  
  /// 再次查询验证更新
  final updatedSnapshots = await timerRepo.queryByField('uuid', timerUnit.uuid);
  if (updatedSnapshots.isNotEmpty) {
    final updatedTimerUnit = TimerUnit.fromSnapshot(updatedSnapshots.first);
    print('4. 验证更新:');
    print('   Status: ${updatedTimerUnit.status}');
  }
  
  /// 删除TimerUnit
  await timerRepo.deleteByField('uuid', timerUnit.uuid);
  print('5. 删除TimerUnit');
  
  /// 验证删除
  final deletedSnapshots = await timerRepo.queryByField('uuid', timerUnit.uuid);
  print('6. 验证删除:');
  if (deletedSnapshots.isEmpty) {
    print('   TimerUnit已成功删除');
  } else {
    print('   删除失败：TimerUnit仍然存在');
  }
}

Future<void> testTaskMappingCRUD(AppStartupService appStartupService) async {
  print('\n=== 测试TaskMapping CRUD操作 ===');
  
  final taskMappingRepo = appStartupService.taskMappingRepo;
  
  /// 创建一个Task
  final task = Task(
    name: '测试任务',
    type: TaskType.timer,
    createdAt: Clock.instance.currentTime,
    opacity: 0.5,
  );
  
  /// 创建一个TimerUnit
  final timerUnit = TimerUnit.countdown(Duration(minutes: 10));
  
  /// 先保存Task和TimerUnit
  await appStartupService.taskRepo.saveSnapshot(task.toSnapshot());
  await appStartupService.timerRepo.saveSnapshot(timerUnit.toSnapshot());
  
  /// 创建TaskMapping
  final taskMapping = TaskMapping(
    taskUuid: task.uuid,
    entityUuid: timerUnit.uuid,
    entityType: 'timer_unit',
  );
  
  print('1. 创建TaskMapping:');
  print('   Task UUID: ${taskMapping.taskUuid}');
  print('   Entity UUID: ${taskMapping.entityUuid}');
  print('   Entity Type: ${taskMapping.entityType}');
  
  /// 保存到数据库
  final snapshot = taskMapping.toSnapshot();
  await taskMappingRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  /// 查询TaskMapping
  final snapshots = await taskMappingRepo.queryByField('task_uuid', task.uuid);
  if (snapshots.isNotEmpty) {
    final loadedTaskMapping = TaskMapping.fromSnapshot(snapshots.first);
    print('2. 查询TaskMapping:');
    print('   Task UUID: ${loadedTaskMapping.taskUuid}');
    print('   Entity UUID: ${loadedTaskMapping.entityUuid}');
    print('   Entity Type: ${loadedTaskMapping.entityType}');
  } else {
    print('   查询失败：未找到TaskMapping');
  }
  
  /// 删除TaskMapping
  await taskMappingRepo.deleteByField('task_uuid', task.uuid);
  print('3. 删除TaskMapping');
  
  /// 删除关联的Task和TimerUnit
  await appStartupService.taskRepo.deleteByField('uuid', task.uuid);
  await appStartupService.timerRepo.deleteByField('uuid', timerUnit.uuid);
  
  /// 验证删除
  final deletedSnapshots = await taskMappingRepo.queryByField('task_uuid', task.uuid);
  print('4. 验证删除:');
  if (deletedSnapshots.isEmpty) {
    print('   TaskMapping已成功删除');
  } else {
    print('   删除失败：TaskMapping仍然存在');
  }
}

