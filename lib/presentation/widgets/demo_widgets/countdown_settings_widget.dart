import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/providers/timer/timer_provider.dart';

class CountdownSettingsWidget extends ConsumerWidget {
  const CountdownSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);
    final controller = ref.read(timerProvider.notifier);

    return timerAsync.when(
      data: (timer) {
        // 只有在倒计时模式下才显示设置控件
        if (!timer.type.isCountdown) {
          return const SizedBox.shrink();
        }

        // 只有在倒计时且未激活时才能设置时间
        final canSetTime = timer.type.isCountdown && timer.status.isInactive;

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
                          final newDuration = timer.duration + const Duration(minutes: 1);
                          await controller.setCountdownDuration(newDuration);
                          await controller.save();
                        }
                      : null,
                  icon: const Icon(Icons.add),
                  iconSize: 30,
                ),
                Text(
                  '${timer.duration.inMinutes} 分钟',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: canSetTime && timer.duration > const Duration(minutes: 1)
                      ? () async {
                          final newDuration = timer.duration - const Duration(minutes: 1);
                          await controller.setCountdownDuration(newDuration);
                          await controller.save();
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
      error: (error, stack) => Text('错误: $error'),
    );
  }
}