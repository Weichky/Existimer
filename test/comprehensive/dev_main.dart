import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:existimer/application/services/app_startup_service.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/domain/task/task.dart';
import 'package:existimer/domain/task/task_mapping.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/core/constants/task_type.dart';
import 'package:existimer/core/utils/clock.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// 导入扩展以使用deleteByField方法
import 'package:existimer/data/repositories/task/task_sqlite.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/data/repositories/task/task_mapping_sqlite.dart';

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

  // 测试Task的CRUD操作
  await testTaskCRUD(appStartupService);
  
  // 测试TimerUnit的CRUD操作
  await testTimerUnitCRUD(appStartupService);
  
  // 测试TaskMapping的CRUD操作
  await testTaskMappingCRUD(appStartupService);

  print('综合测试完成！');
}

Future<void> testTaskCRUD(AppStartupService appStartupService) async {
  print('\n=== 测试Task CRUD操作 ===');
  
  final taskRepo = appStartupService.taskRepo;
  
  // 创建一个Task
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
  
  // 保存到数据库
  final snapshot = task.toSnapshot();
  await taskRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  // 查询Task
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
  
  // 更新Task
  task.setName = '更新后的任务';
  task.setIsHighlighted = true;
  await taskRepo.saveSnapshot(task.toSnapshot());
  print('3. 更新Task:');
  print('   Name更新为: ${task.name}');
  print('   IsHighlighted更新为: ${task.isHighlighted}');
  
  // 再次查询验证更新
  final updatedSnapshots = await taskRepo.queryByField('uuid', task.uuid);
  if (updatedSnapshots.isNotEmpty) {
    final updatedTask = Task.fromSnapshot(updatedSnapshots.first);
    print('4. 验证更新:');
    print('   Name: ${updatedTask.name}');
    print('   IsHighlighted: ${updatedTask.isHighlighted}');
  }
  
  // 删除Task
  await taskRepo.deleteByField('uuid', task.uuid);
  print('5. 删除Task');
  
  // 验证删除
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
  
  // 创建一个倒计时TimerUnit
  final timerUnit = TimerUnit.countdown(Duration(minutes: 25));
  
  print('1. 创建TimerUnit:');
  print('   UUID: ${timerUnit.uuid}');
  print('   Type: ${timerUnit.type}');
  print('   Status: ${timerUnit.status}');
  print('   Duration: ${timerUnit.duration}');
  
  // 保存到数据库
  final snapshot = timerUnit.toSnapshot();
  await timerRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  // 查询TimerUnit
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
  
  // 更新TimerUnit (启动计时器)
  timerUnit.start();
  await timerRepo.saveSnapshot(timerUnit.toSnapshot());
  print('3. 更新TimerUnit:');
  print('   Status更新为: ${timerUnit.status}');
  
  // 再次查询验证更新
  final updatedSnapshots = await timerRepo.queryByField('uuid', timerUnit.uuid);
  if (updatedSnapshots.isNotEmpty) {
    final updatedTimerUnit = TimerUnit.fromSnapshot(updatedSnapshots.first);
    print('4. 验证更新:');
    print('   Status: ${updatedTimerUnit.status}');
  }
  
  // 删除TimerUnit
  await timerRepo.deleteByField('uuid', timerUnit.uuid);
  print('5. 删除TimerUnit');
  
  // 验证删除
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
  
  // 创建一个Task
  final task = Task(
    name: '测试任务',
    type: TaskType.timer,
    createdAt: Clock.instance.currentTime,
    opacity: 0.5,
  );
  
  // 创建一个TimerUnit
  final timerUnit = TimerUnit.countdown(Duration(minutes: 10));
  
  // 先保存Task和TimerUnit
  await appStartupService.taskRepo.saveSnapshot(task.toSnapshot());
  await appStartupService.timerRepo.saveSnapshot(timerUnit.toSnapshot());
  
  // 创建TaskMapping
  final taskMapping = TaskMapping(
    taskUuid: task.uuid,
    entityUuid: timerUnit.uuid,
    entityType: 'timer_unit',
  );
  
  print('1. 创建TaskMapping:');
  print('   Task UUID: ${taskMapping.taskUuid}');
  print('   Entity UUID: ${taskMapping.entityUuid}');
  print('   Entity Type: ${taskMapping.entityType}');
  
  // 保存到数据库
  final snapshot = taskMapping.toSnapshot();
  await taskMappingRepo.saveSnapshot(snapshot);
  print('   已保存到数据库');
  
  // 查询TaskMapping
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
  
  // 删除TaskMapping
  await taskMappingRepo.deleteByField('task_uuid', task.uuid);
  print('3. 删除TaskMapping');
  
  // 删除关联的Task和TimerUnit
  await appStartupService.taskRepo.deleteByField('uuid', task.uuid);
  await appStartupService.timerRepo.deleteByField('uuid', timerUnit.uuid);
  
  // 验证删除
  final deletedSnapshots = await taskMappingRepo.queryByField('task_uuid', task.uuid);
  print('4. 验证删除:');
  if (deletedSnapshots.isEmpty) {
    print('   TaskMapping已成功删除');
  } else {
    print('   删除失败：TaskMapping仍然存在');
  }
}

