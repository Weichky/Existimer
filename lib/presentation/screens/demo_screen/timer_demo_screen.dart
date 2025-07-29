//timer_demo_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/controllers/timer/timer_controller.dart';
import 'package:existimer/application/providers/timer/timer_provider.dart';
import 'package:existimer/application/providers/app_startup_service_provider.dart';
import 'package:existimer/application/services/app_startup_service.dart';
import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/snapshots/timer/timer_unit_snapshot.dart';
import 'package:existimer/core/constants/timer_unit_status.dart';
import 'package:existimer/presentation/widgets/demo_widgets/timer_display_widget.dart';
import 'package:existimer/presentation/widgets/demo_widgets/timer_controls_widget.dart';
import 'package:existimer/presentation/widgets/demo_widgets/timer_type_selector_widget.dart';
import 'package:existimer/presentation/widgets/demo_widgets/countdown_settings_widget.dart';

class TimerDemoScreen extends ConsumerStatefulWidget {
  const TimerDemoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerDemoScreen> createState() => _TimerDemoScreenState();
}

class _TimerDemoScreenState extends ConsumerState<TimerDemoScreen> {
  late Future<void> _initializationFuture;
  
  @override
  void initState() {
    super.initState();
    _initializationFuture = _checkAndRecoverTimer();
  }

  /// 检查并恢复计时器
  Future<void> _checkAndRecoverTimer() async {
    try {
      final appStartupService = await ref.read(appStartupServiceProvider.future);
      
      // 查找所有处于active状态的计时器
      final activeTimers = await appStartupService.timerRepo.queryByField(
        'status', 
        TimerUnitStatus.active.name
      );
      
      // 如果有处于active状态的计时器
      if (activeTimers.isNotEmpty) {
        // 选择第一个active状态的计时器
        final firstActiveTimer = activeTimers.first;
        final shouldRecover = await _showRecoverDialog('发现正在运行的计时器，是否恢复？');
        if (shouldRecover) {
          // 确保TimerController已初始化后再尝试加载计时器
          await ref.read(timerProvider.future).then((_) async {
            await ref.read(timerProvider.notifier).loadFromUuid(firstActiveTimer.uuid);
          });
        } else {
          // 删除计时器
          await appStartupService.timerRepo.deleteByField('uuid', firstActiveTimer.uuid);
        }
        return;
      }
      
      // 如果没有active状态的计时器，查找paused状态的计时器
      final pausedTimers = await appStartupService.timerRepo.queryByField(
        'status', 
        TimerUnitStatus.paused.name
      );
      
      if (pausedTimers.isNotEmpty) {
        // 选择第一个paused状态的计时器
        final firstPausedTimer = pausedTimers.first;
        final shouldRecover = await _showRecoverDialog('发现已暂停的计时器，是否恢复？');
        if (shouldRecover) {
          // 确保TimerController已初始化后再尝试加载计时器
          await ref.read(timerProvider.future).then((_) async {
            await ref.read(timerProvider.notifier).loadFromUuid(firstPausedTimer.uuid);
          });
        } else {
          // 删除计时器
          await appStartupService.timerRepo.deleteByField('uuid', firstPausedTimer.uuid);
        }
      }
    } catch (e) {
      // 发生错误时，继续正常初始化
      print('检查和恢复计时器时出错: $e');
    }
  }
  
  /// 显示恢复对话框
  Future<bool> _showRecoverDialog(String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('恢复计时器'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('否'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('是'),
            ),
          ],
        );
      },
    );
    
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return const TimerDemoScreenContent();
      },
    );
  }
}

class TimerDemoScreenContent extends ConsumerWidget {
  const TimerDemoScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听计时器状态变化
    final timerState = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Existimer 计时器演示'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 计时器显示区域
            const TimerDisplayWidget(),
            
            const SizedBox(height: 32),
            
            // 计时器类型选择器
            const TimerTypeSelectorWidget(),
            
            const SizedBox(height: 16),
            
            // 倒计时设置（仅在倒计时模式下显示）
            const CountdownSettingsWidget(),
            
            const SizedBox(height: 32),
            
            // 计时器控制按钮
            const TimerControlsWidget(),
          ],
        ),
      ),
    );
  }
}