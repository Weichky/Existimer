import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/providers/timer/timer_provider.dart';
import 'package:existimer/presentation/widgets/demo_widgets/timer_display_widget.dart';
import 'package:existimer/presentation/widgets/demo_widgets/timer_controls_widget.dart';
import 'package:existimer/presentation/widgets/demo_widgets/timer_type_selector_widget.dart';
import 'package:existimer/presentation/widgets/demo_widgets/countdown_settings_widget.dart';

class TimerDemoScreen extends ConsumerWidget {
  const TimerDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('计时器演示'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 显示计时器时间
            const TimerDisplayWidget(),
            
            const SizedBox(height: 30),
            
            // 控制按钮
            const TimerControlsWidget(),
            
            const SizedBox(height: 30),
            
            // 计时器类型选择器
            const TimerTypeSelectorWidget(),
            
            const SizedBox(height: 20),
            
            // 倒计时设置
            const CountdownSettingsWidget(),
            
            const SizedBox(height: 20),
            
            // 显示当前状态和类型
            timerAsync.when(
              data: (timer) {
                return Column(
                  children: [
                    Text(
                      '状态: ${timer.status.toString().split('.').last}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '类型: ${timer.type.toString().split('.').last}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'UUID: ${timer.uuid}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('错误: $error'),
            ),
          ],
        ),
      ),
    );
  }
}