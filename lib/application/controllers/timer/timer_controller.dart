import 'dart:async';

import 'package:existimer/application/controllers/base_controller.dart';
import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/application/providers/settings/settings_provider.dart';
import 'package:existimer/application/providers/timer/timer_repo_provider.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/data/snapshots/timer/timer_unit_snapshot.dart';
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
    /// ref.read()不会触发build()，因此此处build相当于初始化方法，关于热重载的问题还需考察
    _repo = await ref.read(timerRepoProvider.future);
    _settings = await ref.read(settingsProvider.future);

    return _settings.defaultTimerUnitType!.isCountup
        ? TimerUnit.countup()
        : TimerUnit.countdown(_settings.countdownDuration!);
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
    final TimerUnitSnapshot? snapshot = await _repo.queryByUuid(uuid);
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
    /// 不作state.valueOrNull处理，此时State不应该为Null
    final unit = state.requireValue;

    try {
      unit.start();
      state = AsyncData(unit); /// 更新状态
    } catch (e, st) {
      /// 捕获错误并将错误更新到 state
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
  
  /// 重置计时器到默认状态
  Future<void> reset() async {
    final unit = state.requireValue;
    
    try {
      /// 使用TimerUnit的reset方法重置计时器
      if (unit.type.isCountup) {
        unit.reset();
      } else {
        unit.reset(_settings.countdownDuration);
      }
      state = AsyncData(unit);
    } catch (e, st) {
      handleError(e, st);
    }
  }
  
  /// 更改计时器类型但保持当前状态（如果可能）
  Future<void> switchType() async {
    final unit = state.requireValue;
    
    try {
      /// 切换类型
      if (unit.type.isCountup) {
        /// 切换到倒计时，使用默认时长
        unit.toCountdown(_settings.countdownDuration!);
      } else {
        /// 切换到正计时
        unit.toCountup();
      }
      state = AsyncData(unit);
    } catch (e, st) {
      handleError(e, st);
    }
  }
  
  /// 设置倒计时持续时间但保持当前状态
  Future<void> setCountdownDuration(Duration duration) async {
    final unit = state.requireValue;
    
    try {
      /// 只有在计时器未激活时才能更改持续时间
      if (unit.status.isInactive) {
        if (unit.type.isCountdown) {
          /// 如果已经是倒计时器，只更改持续时间
          unit.toCountdown(duration);
        } else {
          /// 如果是正计时器，切换到倒计时器
          unit.toCountdown(duration);
        }
        state = AsyncData(unit);
      }
    } catch (e, st) {
      handleError(e, st);
    }
  }
  
  /// 应用最新的设置，更新计时器配置
  Future<void> applySettings() async {
    final unit = state.requireValue;
    
    try {
      /// 如果是倒计时器且未激活，则更新其持续时间
      if (unit.type.isCountdown && unit.status.isInactive) {
        unit.toCountdown(_settings.countdownDuration!);
        state = AsyncData(unit);
      }
    } catch (e, st) {
      handleError(e, st);
    }
  }
}