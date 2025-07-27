import 'dart:async';

import 'package:existimer/application/controllers/collection_controller.dart';
import 'package:existimer/application/providers/task_mapping_repo_provider.dart';
import 'package:existimer/data/repositories/task/task_mapping_sqlite.dart';
import 'package:existimer/domain/task/task_mapping.dart';
import 'package:existimer/snapshots/task/task_mapping_snapshot.dart';
import 'package:riverpod/riverpod.dart';

/// 任务映射控制器
/// 
/// 管理任务与实体之间的映射关系
/// 提供对任务映射的增删查操作
/// 继承自CollectionController，实现统一的Controller设计模式
class TaskMappingController extends CollectionController<TaskMapping> {
  /// 任务映射数据访问对象
  late TaskMappingSqlite _repo;

  /// 构建控制器初始状态
  /// 
  /// 初始化数据访问对象并返回空的任务映射列表
  @override
  Future<List<TaskMapping>> build() async {
    _repo = await ref.read(taskMappingRepoProvider.future);
    // 初始化为空列表
    return [];
  }

  /// 加载数据（未实现）
  /// 
  /// BaseController要求实现的方法
  @override
  Future<void> load() async {
    // TaskMappingController使用专门的加载方法
    throw UnimplementedError('Use specific load methods instead');
  }

  /// 保存数据（未实现）
  /// 
  /// BaseController要求实现的方法
  @override
  Future<void> save() async {
    // TaskMapping通过addMapping方法保存单个映射
    throw UnimplementedError('Use addMapping instead');
  }

  /// 添加项目到集合
  /// 
  /// [item] 要添加的任务映射对象
  @override
  Future<void> addItem(TaskMapping item) async {
    await addMapping(item);
  }

  /// 从集合中移除项目
  /// 
  /// [predicate] 判断是否应该移除项目的条件
  @override
  Future<void> removeWhere(bool Function(TaskMapping item) predicate) async {
    final currentList = state.value ?? [];
    final itemsToRemove = currentList.where(predicate).toList();
    
    for (final item in itemsToRemove) {
      await deleteMapping(item.taskUuid, item.entityUuid);
    }
  }

  /// 更新集合中的项目（TaskMapping不支持更新操作）
  /// 
  /// [predicate] 判断是否应该更新的项目的条件
  /// [updater] 更新项目的函数
  @override
  Future<void> updateWhere(
    bool Function(TaskMapping item) predicate,
    TaskMapping Function(TaskMapping item) updater,
  ) async {
    // TaskMapping是映射关系，不支持更新操作
    throw UnsupportedError('TaskMapping does not support update operation');
  }

  /// 加载特定任务的映射关系
  /// 
  /// [taskUuid] 任务UUID
  Future<void> loadMappingsForTask(String taskUuid) async {
    try {
      final snapshots = await _repo.loadMappingsForTask(taskUuid);
      final mappings = snapshots.map((s) => TaskMapping.fromSnapshot(s)).toList();
      state = AsyncData(mappings);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// 加载特定实体的映射关系
  /// 
  /// [entityUuid] 实体UUID
  Future<void> loadMappingsForEntity(String entityUuid) async {
    try {
      final snapshots = await _repo.loadMappingsForEntity(entityUuid);
      final mappings = snapshots.map((s) => TaskMapping.fromSnapshot(s)).toList();
      state = AsyncData(mappings);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// 添加新的映射关系
  /// 
  /// [mapping] 要添加的任务映射对象
  Future<void> addMapping(TaskMapping mapping) async {
    try {
      await _repo.saveSnapshot(mapping.toSnapshot());
      // 更新状态
      final currentList = state.value ?? [];
      final newList = List<TaskMapping>.from(currentList)..add(mapping);
      state = AsyncData(newList);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// 删除映射关系
  /// 
  /// [taskUuid] 任务UUID
  /// [entityUuid] 实体UUID
  Future<void> deleteMapping(String taskUuid, String entityUuid) async {
    try {
      await _repo.deleteMapping(taskUuid, entityUuid);
      // 更新状态
      final currentList = state.value ?? [];
      final newList = currentList.where((mapping) => 
        mapping.taskUuid != taskUuid || mapping.entityUuid != entityUuid).toList();
      state = AsyncData(newList);
    } catch (e, st) {
      handleError(e, st);
    }
  }
}