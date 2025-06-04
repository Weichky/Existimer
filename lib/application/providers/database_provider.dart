import 'package:riverpod/riverpod.dart';
import 'package:existimer/data/repositories/app_database.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final db = AppDatabase();
  await db.init();
  return db;
});