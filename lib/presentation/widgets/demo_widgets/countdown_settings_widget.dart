import 'package:existimer/application/providers/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/providers/timer/timer_provider.dart';

class CountdownSettingsWidget extends ConsumerWidget {
  const CountdownSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final settingsController = ref.read(settingsProvider.notifier);
    final timerController = ref.read(timerProvider.notifier);

    

    return timerAsync.when(
      data: (timer) {
        // 只有在倒计时模式下才显示设置控件
        if (!timer.type.isCountdown) {
          return const SizedBox.shrink();
        }

        // 只有在倒计时且未激活时才能设置时间
        final canSetTime = timer.type.isCountdown && timer.status.isInactive;

        return settingsAsync.when(
          data: (settings) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '倒计时设置:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: canSetTime
                          ? () async {
                              final newDuration = settings.countdownDuration! + const Duration(minutes: 1);
                              await settingsController.setCountdownDuration(newDuration);
                              await settingsController.save();
                              // 应用新设置到当前计时器
                              await timerController.applySettings();
                            }
                          : null,
                      icon: const Icon(Icons.add),
                      iconSize: 30,
                    ),
                    Text(
                      '${settings.countdownDuration!.inMinutes} 分钟',
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: canSetTime && settings.countdownDuration! > const Duration(minutes: 1)
                          ? () async {
                              final newDuration = settings.countdownDuration! - const Duration(minutes: 1);
                              await settingsController.setCountdownDuration(newDuration);
                              await settingsController.save();
                              // 应用新设置到当前计时器
                              await timerController.applySettings();
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                      iconSize: 30,
                    ),
                  ],
                ),
                if (!timer.status.isInactive)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      '注意：只能在计时器停止时更改时间',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('设置加载错误: $error'),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('计时器加载错误: $error'),
    );
  }
}