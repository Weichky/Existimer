// timer_repo_provider.dart
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:riverpod/riverpod.dart';
import 'app_startup_service_provider.dart';

final timerRepoProvider = FutureProvider<TimerUnitSqlite>((ref) {
  final appStartupService = ref.watch(appStartupServiceReadyProvider);
  return appStartupService.timerRepo;
});
