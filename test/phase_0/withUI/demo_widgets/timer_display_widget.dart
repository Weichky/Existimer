import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/providers/timer/timer_provider.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/common/utils/clock.dart';

class TimerDisplayWidget extends ConsumerStatefulWidget {
  const TimerDisplayWidget({super.key});

  @override
  ConsumerState<TimerDisplayWidget> createState() => _TimerDisplayWidgetState();
}

class _TimerDisplayWidgetState extends ConsumerState<TimerDisplayWidget> {
  late Timer _frontendTimer;
  late Timer _backendSyncTimer;
  Duration _displayDuration = Duration.zero;
  DateTime _lastSyncTime = Clock.instance.currentTime;
  Duration? _lastKnownDuration;
  String _lastTimerUuid = '';

  @override
  void initState() {
    super.initState();
    _startFrontendTimer();
    _startBackendSyncTimer();
  }

  @override
  void dispose() {
    _frontendTimer.cancel();
    _backendSyncTimer.cancel();
    super.dispose();
  }

  void _startFrontendTimer() {
    // 前端计时器，每10毫秒更新一次显示，实现毫秒级流畅显示
    _frontendTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      final timerAsync = ref.read(timerProvider);
      timerAsync.whenData((timerUnit) {
        // 检查计时器是否已更改（例如重置或创建了新实例）
        if (timerUnit.uuid != _lastTimerUuid) {
          _lastTimerUuid = timerUnit.uuid;
          _lastSyncTime = Clock.instance.currentTime;
          _lastKnownDuration = timerUnit.duration;
          setState(() {
            _displayDuration = timerUnit.duration;
          });
          return;
        }

        // 只有在计时器正在运行时才进行前端计算
        if (timerUnit.status.isActive) {
          // 获取当前时间
          final now = Clock.instance.currentTime;
          
          // 计算从上次同步以来经过的时间
          final elapsed = now.difference(_lastSyncTime);
          
          // 根据计时器类型和上次同步的时间计算显示时间
          if (timerUnit.type.isCountup) {
            // 正计时：上次同步的时间 + 经过的时间
            if (_lastKnownDuration != null) {
              setState(() {
                _displayDuration = _lastKnownDuration! + elapsed;
              });
            }
          } else {
            // 倒计时：上次同步的时间 - 经过的时间
            if (_lastKnownDuration != null) {
              final newDuration = _lastKnownDuration! - elapsed;
              setState(() {
                _displayDuration = newDuration.isNegative ? Duration.zero : newDuration;
              });
            }
          }
        } else {
          // 如果计时器未运行，直接显示同步的时间
          setState(() {
            _displayDuration = timerUnit.duration;
          });
        }
      });
    });
  }

  void _startBackendSyncTimer() {
    // 后端同步计时器，每秒同步一次确保准确性
    _backendSyncTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final controller = ref.read(timerProvider.notifier);
      final timerAsync = ref.read(timerProvider);
      
      // 更新上次同步时间和已知持续时间
      timerAsync.whenData((timerUnit) {
        // 检查计时器是否已更改
        if (timerUnit.uuid != _lastTimerUuid) {
          _lastTimerUuid = timerUnit.uuid;
        }
        
        setState(() {
          _lastSyncTime = Clock.instance.currentTime;
          _lastKnownDuration = timerUnit.duration;
        });
      });
      
      // 保存当前状态到数据库
      await controller.save();
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerAsync = ref.watch(timerProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(_displayDuration),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          timerAsync.when(
            data: (timer) {
              // 当计时器状态发生变化时，更新同步时间和已知持续时间
              if (_lastKnownDuration == null || 
                  timer.uuid != _lastTimerUuid ||
                  timer.duration != _lastKnownDuration ||
                  _lastSyncTime.difference(Clock.instance.currentTime).abs() > const Duration(milliseconds: 100)) {
                _lastTimerUuid = timer.uuid;
                _lastSyncTime = Clock.instance.currentTime;
                _lastKnownDuration = timer.duration;
              }
              
              if (timer.type.isCountdown) {
                return const Text(
                  '倒计时',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                );
              } else {
                return const Text(
                  '正计时',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                );
              }
            },
            loading: () => const Text('加载中...'),
            error: (error, stack) => Text('错误: $error'),
          ),
        ],
      ),
    );
  }
}