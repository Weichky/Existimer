import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:existimer/application/services/database_init_service.dart';
import 'package:existimer/application/providers/app_startup_service_provider.dart';
import 'demo_screen/timer_demo_screen.dart';

void main() async {
  // 初始化数据库环境
  DatabaseInitService.initDatabaseEnvironment();

  runApp(
    ProviderScope(
      child: DemoApp(),
    ),
  );
}

class DemoApp extends ConsumerWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 等待应用启动服务初始化完成
    final appStartupAsync = ref.watch(appStartupServiceProvider);

    return MaterialApp(
      title: 'Existimer 计时器演示',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: appStartupAsync.when(
        data: (appStartupService) => const TimerDemoScreen(),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Text('初始化错误: $error'),
          ),
        ),
      ),
    );
  }
}