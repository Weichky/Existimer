// app_startup_service_provider.dart
import 'package:riverpod/riverpod.dart';
import 'package:existimer/application/services/app_startup_service.dart';
import 'database_provider.dart';

// 先创建AppStartupService实例（异步）
final appStartupServiceProvider = FutureProvider<AppStartupService>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  final service = AppStartupService(database: db);
  await service.initializeApp();  // 这里务必调用初始化
  return service;
});

// 同步Provider，方便获取已经初始化好的service
final appStartupServiceReadyProvider = Provider<AppStartupService>((ref) {
  final asyncService = ref.watch(appStartupServiceProvider);
  return asyncService.requireValue;
});
