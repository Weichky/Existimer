import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/providers/timer/timer_provider.dart';

class TimerTypeSelectorWidget extends ConsumerWidget {
  const TimerTypeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);
    final controller = ref.read(timerProvider.notifier);

    return timerAsync.when(
      data: (timer) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '计时器类型:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('正计时'),
                  selected: timer.type.isCountup,
                  onSelected: timer.status.isInactive
                      ? (selected) async {
                          if (selected && timer.type.isCountdown) {
                            // 切换到正计时
                            await controller.switchType();
                            await controller.save();
                          }
                        }
                      : null,
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('倒计时'),
                  selected: timer.type.isCountdown,
                  onSelected: timer.status.isInactive
                      ? (selected) async {
                          if (selected && timer.type.isCountup) {
                            // 切换到倒计时
                            await controller.switchType();
                            await controller.save();
                          }
                        }
                      : null,
                ),
              ],
            ),
            if (!timer.status.isInactive)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '注意：只能在计时器停止时更改类型',
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