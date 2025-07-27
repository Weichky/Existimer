import 'package:riverpod/riverpod.dart';

/// 控制器基类
/// 
/// 为所有控制器提供通用的功能和接口
/// 统一Controller的设计模式，提高代码的一致性和可维护性
abstract class BaseController<T> extends AsyncNotifier<T> {
  /// 构造函数
  BaseController();

  /// 加载数据
  /// 
  /// 子类需要实现具体的加载逻辑
  Future<void> load();

  /// 保存数据
  /// 
  /// 子类需要实现具体的保存逻辑
  Future<void> save();

  /// 处理错误
  /// 
  /// [error] 错误对象
  /// [stackTrace] 堆栈跟踪信息
  void handleError(Object error, StackTrace stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}