import 'package:flutter/widgets.dart';
import 'package:potato_task/application/services/app_startup_service.dart';
import 'package:potato_task/data/repositories/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final AppDatabase appDatabase = AppDatabase();
  await appDatabase.init();
  
  final AppStartupService appStartupService = AppStartupService(
    database: appDatabase,
  );

  await appStartupService.initializeApp();
}