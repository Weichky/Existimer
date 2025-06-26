import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:riverpod/riverpod.dart';

import 'package:existimer/application/providers/timer_provider.dart';
import 'package:existimer/application/providers/app_startup_service_provider.dart';
import 'package:existimer/application/providers/database_provider.dart';

import 'package:existimer/domain/timer/timer_unit.dart';
import 'package:existimer/core/constants/timer_unit_status.dart';
import 'package:existimer/core/constants/timer_unit_type.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() async {
    // 初始化 sqflite ffi，针对桌面环境
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    container = ProviderContainer();

    // 等待 AppStartupService 完成初始化（隐式触发数据库初始化和AppStartupService初始化）
    await container.read(appStartupServiceProvider.future);
  });

  tearDown(() {
    container.dispose();
  });

  test('timerProvider 默认初始化', () async {
    final timer = await container.read(timerProvider.future);

    print('timer type: ${timer.type}');
    print('timer duration: ${timer.duration}');
    print('timer status: ${timer.status}');

    expect(timer.type, TimerUnitType.countdown);
    expect(timer.duration, const Duration(seconds: 25));
    expect(timer.status, TimerUnitStatus.inactive);
  });

  test('timerProvider 保存与加载', () async {
    final controller = container.read(timerProvider.notifier);

    // 启动计时器
    await controller.start();

    // 保存计时器状态到数据库
    await controller.save();

    final uuid = container.read(timerProvider).value!.uuid;

    // 加载刚保存的计时器
    await controller.loadFromUuid(uuid);

    final loadedTimer = container.read(timerProvider).value!;
    print('loaded timer uuid: ${loadedTimer.uuid}');
    print('loaded timer status: ${loadedTimer.status}');

    expect(loadedTimer.uuid, uuid);
    expect(loadedTimer.status, TimerUnitStatus.active);
  });
}
