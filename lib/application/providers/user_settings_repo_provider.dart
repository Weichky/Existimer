import 'package:existimer/application/providers/database_provider.dart';
import 'package:existimer/data/repositories/configs/user_settings_sqlite.dart';

import 'package:riverpod/riverpod.dart';

final userSettingsRepoProvider = FutureProvider<UserSettingsSqlite>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return UserSettingsSqlite(db.db);
});