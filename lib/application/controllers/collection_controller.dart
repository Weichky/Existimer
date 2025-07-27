import 'package:existimer/application/controllers/base_controller.dart';
import 'package:riverpod/riverpod.dart';

/// 集合控制器基类
/// 
/// 为管理集合数据的控制器提供通用的功能和接口
/// 继承自BaseController，实现统一的Controller设计模式
abstract class CollectionController<T> extends BaseController<List<T>> {
  /// 构造函数
  CollectionController();

  /// 添加项目到集合
  /// 
  /// [item] 要添加的项目
  Future<void> addItem(T item);

  /// 从集合中移除项目
  /// 
  /// [predicate] 判断是否应该移除项目的条件
  Future<void> removeWhere(bool Function(T item) predicate);

  /// 更新集合中的项目
  /// 
  /// [predicate] 判断是否应该更新的项目的条件
  /// [updater] 更新项目的函数
  Future<void> updateWhere(
    bool Function(T item) predicate,
    T Function(T item) updater,
  );
}