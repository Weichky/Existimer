import 'package:potato_task/snapshots/timerunit_snapshot.dart';

abstract class TimerUnitRepository {
  Future<void> saveSnapshot(TimerUnitSnapshot snapshot);
  Future<TimerUnitSnapshot?> loadSnapshot(String uuid);
}