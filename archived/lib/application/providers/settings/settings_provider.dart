//settings_provider.dart
import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/application/controllers/settings/settings_controller.dart';
import 'package:riverpod/riverpod.dart';

final settingsProvider = AsyncNotifierProvider< SettingsController, Settings>(
  () => SettingsController(),
);