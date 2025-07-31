import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/common/utils/clock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 创建正向计时器
  final timerUnit = TimerUnit.countup();
  print('创建计时器: ${timerUnit.uuid}');
  print('初始状态 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 开始计时
  print('\n开始计时...');
  timerUnit.start();
  print('开始后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 运行1秒
  await Future.delayed(const Duration(seconds: 1));
  print('1秒后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 再运行1秒
  await Future.delayed(const Duration(seconds: 1));
  print('再1秒后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 暂停
  print('\n暂停计时...');
  timerUnit.pause();
  print('暂停后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 等待1秒（暂停状态下）
  await Future.delayed(const Duration(seconds: 1));
  print('暂停1秒后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 再等待1秒（暂停状态下）
  await Future.delayed(const Duration(seconds: 1));
  print('再暂停1秒后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 恢复计时
  print('\n恢复计时...');
  timerUnit.resume();
  print('恢复后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 运行1秒
  await Future.delayed(const Duration(seconds: 1));
  print('恢复后1秒 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 再运行1秒
  await Future.delayed(const Duration(seconds: 1));
  print('再1秒后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  /// 停止计时器
  print('\n停止计时器...');
  timerUnit.stop();
  print('停止后 - 时间: ${timerUnit.duration.inMilliseconds}ms, 状态: ${timerUnit.status}');
  
  print('\n测试完成');
}