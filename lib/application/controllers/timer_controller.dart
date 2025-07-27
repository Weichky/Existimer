import 'dart:async';

import 'package:existimer/application/controllers/base_controller.dart';
import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/application/providers/config_provider.dart';
import 'package:existimer/application/providers/timer_repo_provider.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/snapshots/timer/timer_unit_snapshot.dart';
import 'package:riverpod/riverpod.dart';

/// 计时器控制器
/// 
/// 管理单个计时器的状态和操作
/// 继承自BaseController，实现统一的Controller设计模式
class TimerController extends BaseController<TimerUnit> {
  late TimerUnitSqlite _repo;
  late Settings _settings;

  /// 构建控制器初始状态
  /// 
  /// 初始化数据访问对象和设置
  /// 根据默认设置创建计时器
  @override
  Future<TimerUnit> build() async {
    // ref.read()不会触发build()，因此此处build相当于初始化方法，关于热重载的问题还需考察
    _repo = await ref.read(timerRepoProvider.future);
    _settings = await ref.read(configProvider.future);

    return _settings.defaultTimerUnitType!.isCountup
        ? TimerUnit.countup()
        : TimerUnit.countdown(_settings.countdownDuration!);
  }

  /// 加载数据（未实现）
  /// 
  /// BaseController要求实现的方法
  @override
  Future<void> load() async {
    // 对于TimerController，加载操作通过loadFromUuid方法实现
    throw UnimplementedError('Use loadFromUuid instead');
  }

  /// 保存数据
  /// 
  /// 将当前计时器状态保存到数据库
  @override
  Future<void> save() async {
    final TimerUnit unit = await future;

    try {
      await _repo.saveSnapshot(unit.toSnapshot());
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// 从UUID加载计时器
  /// 
  /// [uuid] 计时器UUID
  Future<void> loadFromUuid(String uuid) async {
    final TimerUnitSnapshot? snapshot = await _repo.loadSnapshot(uuid);
    if (snapshot != null) {
      state = AsyncData(TimerUnit.fromSnapshot(snapshot));
    } else {
      state = AsyncError(StateError('Timer not found'), StackTrace.current);
    }
  }

  /// 创建计时器
  /// 
  /// [snapshot] 计时器快照
  Future<void> create(TimerUnitSnapshot snapshot) async {
    state = AsyncData(TimerUnit.fromSnapshot(snapshot));
  }

  /// 启动计时器
  Future<void> start() async {
    // 不作state.valueOrNull处理，此时State不应该为Null
    final unit = state.requireValue;

    try {
      unit.start();
      state = AsyncData(unit); // 更新状态
    } catch (e, st) {
      // 捕获错误并将错误更新到 state
      handleError(e, st);
    }
  }

  /// 停止计时器
  Future<void> stop() async {
    final unit = state.requireValue;

    try {
      unit.stop();
      state = AsyncData(unit);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// 暂停计时器
  Future<void> pause() async {
    final unit = state.requireValue;

    try {
      unit.pause();
      state = AsyncData(unit);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// 恢复计时器
  Future<void> resume() async {
    final unit = state.requireValue;

    try {
      unit.resume();
      state = AsyncData(unit);
    } catch (e, st) {
      handleError(e, st);
    }
  }
}