import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/providers/timer/timer_provider.dart';

class TimerControlsWidget extends ConsumerWidget {
  const TimerControlsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);
    final controller = ref.read(timerProvider.notifier);

    return timerAsync.when(
      data: (timer) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 开始/恢复按钮
            if (timer.status.isInactive || timer.status.isPaused)
              FloatingActionButton(
                heroTag: "start",
                onPressed: () async {
                  if (timer.status.isInactive) {
                    await controller.start();
                  } else if (timer.status.isPaused) {
                    await controller.resume();
                  }
                  // 保存状态到数据库
                  await controller.save();
                },
                backgroundColor: Colors.green,
                child: Icon(
                  timer.status.isInactive ? Icons.play_arrow : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),

            const SizedBox(width: 16),

            // 暂停按钮
            if (timer.status.isActive)
              FloatingActionButton(
                heroTag: "pause",
                onPressed: () async {
                  await controller.pause();
                  // 保存状态到数据库
                  await controller.save();
                },
                backgroundColor: Colors.orange,
                child: const Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
              ),

            const SizedBox(width: 16),

            // 停止按钮
            if (!timer.status.isInactive)
              FloatingActionButton(
                heroTag: "stop",
                onPressed: () async {
                  await controller.stop();
                  await controller.reset(); // 停止后自动重置
                  // 保存状态到数据库
                  await controller.save();
                },
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
              ),

            const SizedBox(width: 16),

            // 重置按钮
            FloatingActionButton(
              heroTag: "reset",
              onPressed: () async {
                await controller.reset();
                // 保存状态到数据库
                await controller.save();
              },
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
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