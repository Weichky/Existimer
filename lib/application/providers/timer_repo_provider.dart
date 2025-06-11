import 'package:existimer/application/providers/database_provider.dart';
import 'package:existimer/data/repositories/timer_unit/timer_unit_sqlite.dart';
import 'package:riverpod/riverpod.dart';

final timerRepoProvider = FutureProvider<TimerUnitSqlite>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return TimerUnitSqlite(db.db);
});