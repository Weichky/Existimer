import 'package:existimer/application/providers/database_provider.dart';
import 'package:existimer/application/services/app_startup_service.dart';
import 'package:riverpod/riverpod.dart';

final appStartupServiceProvider = FutureProvider<AppStartupService>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  final service = AppStartupService(database: db);
  return service;
});