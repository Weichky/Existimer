import 'package:existimer/application/providers/app_startup_service_provider.dart';
import 'package:riverpod/riverpod.dart';

/// Repository Provider工厂类
/// 
/// 用于创建通用的Repository Provider，减少重复代码
/// 提高代码的可维护性和一致性
class RepositoryProviderFactory {
  /// 创建Repository Provider
  /// 
  /// [getter] 从AppStartupService获取Repository实例的方法
  /// 返回一个FutureProvider，提供指定类型的Repository实例
  static FutureProvider<T> createRepositoryProvider<T>(
    T Function(dynamic appStartupService) getter
  ) {
    return FutureProvider<T>((ref) {
      final appStartupService = ref.watch(appStartupServiceReadyProvider);
      return getter(appStartupService);
    });
  }
}