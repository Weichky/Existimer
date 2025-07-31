// app_startup_service_provider.dart
import 'package:riverpod/riverpod.dart';
import 'package:existimer/application/services/app_startup_service.dart';
import 'package:existimer/application/services/database_init_service.dart';
import 'database_provider.dart';

// 先创建AppStartupService实例（异步）
final appStartupServiceProvider = FutureProvider<AppStartupService>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  final service = AppStartupService(database: db);
  await service.initializeApp();  /// 这里务必调用初始化
  return service;
});

// 移除 appStartupServiceReadyProvider，因为直接使用 requireValue 会导致状态错误
// 如果需要同步访问已经初始化好的service，应该使用 ref.watch(appStartupServiceProvider).valueOrNull
