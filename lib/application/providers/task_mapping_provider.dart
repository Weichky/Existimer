import 'package:existimer/application/controllers/task_mapping_controller.dart';
import 'package:existimer/domain/task/task_mapping.dart';
import 'package:riverpod/riverpod.dart';

final taskMappingProvider = AsyncNotifierProvider<TaskMappingController, List<TaskMapping>>(
  () => TaskMappingController(),
);