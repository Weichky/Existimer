//settings_provider.dart
import 'package:existimer/application/settings/settings.dart';
import 'package:existimer/application/controllers/config_controller.dart';
import 'package:riverpod/riverpod.dart';

final configProvider = AsyncNotifierProvider< ConfigController, Settings>(
  () => ConfigController(),
);