//settings_provider.dart
import 'package:existimer/application/configs/user_settings.dart';
import 'package:existimer/application/controllers/config_controller.dart';
import 'package:riverpod/riverpod.dart';

final configProvider = AsyncNotifierProvider< ConfigController, UserSettings>(
  () => ConfigController(),
);