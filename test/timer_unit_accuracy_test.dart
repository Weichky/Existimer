import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:existimer/application/services/app_startup_service.dart';
import 'package:existimer/data/repositories/app_database.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/core/utils/clock.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/snapshots/timer/timer_unit_snapshot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final AppDatabase appDatabase = AppDatabase();
  await appDatabase.init();

  final AppStartupService appStartupService = AppStartupService(database: appDatabase);
  await appStartupService.initializeApp();

  final TimerUnitSqlite timerRepo = appStartupService.timerRepo;

  // 创建正向计时器
  final timerUnit = TimerUnit.countup();
  print('创建计时器: ${timerUnit.uuid}');
  
  // 前端显示相关变量
  Duration displayDuration = Duration.zero;
  DateTime lastSyncTime = Clock.instance.currentTime;
  Duration? lastKnownDuration;
  String lastTimerUuid = timerUnit.uuid;
  
  int round = 1;
  bool isRunning = false;
  
  // 模拟前端定时器（每10ms更新显示）
  Timer frontendTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
    if (!isRunning) return;
    
    // 检查计时器是否已更改
    if (timerUnit.uuid != lastTimerUuid) {
      lastTimerUuid = timerUnit.uuid;
      lastSyncTime = Clock.instance.currentTime;
      lastKnownDuration = timerUnit.duration;
      displayDuration = timerUnit.duration;
      print('计时器已重置，UUID: ${timerUnit.uuid}');
      return;
    }

    // 只有在计时器正在运行时才进行前端计算
    if (timerUnit.status.isActive) {
      // 获取当前时间
      final now = Clock.instance.currentTime;
      
      // 计算从上次同步以来经过的时间
      final elapsed = now.difference(lastSyncTime);
      
      // 根据计时器类型和上次同步的时间计算显示时间
      if (timerUnit.type.isCountup) {
        // 正计时：上次同步的时间 + 经过的时间
        if (lastKnownDuration != null) {
          displayDuration = lastKnownDuration! + elapsed;
        }
      }
    } else {
      // 如果计时器未运行，直接显示同步的时间
      displayDuration = timerUnit.duration;
    }
  });
  
  // 模拟后端同步定时器（每1秒同步一次）
  Timer backendSyncTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!isRunning) return;
    
    // 检查计时器是否已更改
    if (timerUnit.uuid != lastTimerUuid) {
      lastTimerUuid = timerUnit.uuid;
    }
    
    lastSyncTime = Clock.instance.currentTime;
    lastKnownDuration = timerUnit.duration;
    
    // 保存到数据库
    timerRepo.saveSnapshot(timerUnit.toSnapshot());
    print('后端同步 - 计时器状态已保存到数据库');
  });
  
  timerUnit.start();
  bool isFirstRun = true;

  // 运行6轮测试
  for (int i = 0; i < 6; i++) {
    print('\n========== 第 ${i + 1} 轮测试 ==========');
    
    // 开始计时
    print('开始计时...');
    if (isFirstRun) {
      isFirstRun = false;
    } else {
      timerUnit.resume();
    }
    isRunning = true;
    
    // 运行5秒
    await Future.delayed(const Duration(seconds: 5));
    print('5秒后 - 前端显示时间: ${displayDuration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(displayDuration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
    
    // 暂停
    print('暂停计时...');
    timerUnit.pause();
    isRunning = false;
    print('暂停时 - 前端显示时间: ${displayDuration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(displayDuration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
    
    // 等待5秒
    await Future.delayed(const Duration(seconds: 5));
    print('暂停5秒后 - 前端显示时间: ${displayDuration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(displayDuration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
    
    // 从数据库加载状态进行校验
    final snapshots = await timerRepo.queryByField('uuid', timerUnit.uuid);
    if (snapshots.isNotEmpty) {
      final loadedTimer = TimerUnit.fromSnapshot(snapshots.first);
      print('数据库状态 - 数据库时间: ${loadedTimer.duration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(loadedTimer.duration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
    }
    
    // 恢复计时
    print('恢复计时...');
    timerUnit.resume();
    isRunning = true;
    
    // 等待5秒
    await Future.delayed(const Duration(seconds: 5));
    print('恢复后5秒 - 前端显示时间: ${displayDuration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(displayDuration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
    
    // 再次从数据库加载状态进行校验
    final snapshots2 = await timerRepo.queryByField('uuid', timerUnit.uuid);
    if (snapshots2.isNotEmpty) {
      final loadedTimer = TimerUnit.fromSnapshot(snapshots2.first);
      print('数据库状态 - 数据库时间: ${loadedTimer.duration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(loadedTimer.duration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
    }

    timerUnit.pause();
  }
  
  // 停止计时器
  print('\n========== 停止计时器 ==========');
  timerUnit.stop();
  isRunning = false;
  print('最终时间 - 前端显示时间: ${displayDuration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(displayDuration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
  
  // 从数据库加载最终状态进行校验
  final finalSnapshots = await timerRepo.queryByField('uuid', timerUnit.uuid);
  if (finalSnapshots.isNotEmpty) {
    final loadedTimer = TimerUnit.fromSnapshot(finalSnapshots.first);
    print('最终数据库状态 - 数据库时间: ${loadedTimer.duration.inMilliseconds}ms, 后端实际时间: ${timerUnit.duration.inMilliseconds}ms, 误差: ${(loadedTimer.duration.inMilliseconds - timerUnit.duration.inMilliseconds).abs()}ms');
  }
  
  // 取消定时器
  frontendTimer.cancel();
  backendSyncTimer.cancel();
  
  print('\n========== 测试完成 ==========');
  print('理论总时间: 6轮 × (5秒运行 + 5秒暂停) = 60秒');
  print('实际计时时间: 6轮 × 5秒运行 = 30秒');
  print('最终计时器时间: ${timerUnit.duration.inSeconds}秒${timerUnit.duration.inMilliseconds % 1000}毫秒');
}