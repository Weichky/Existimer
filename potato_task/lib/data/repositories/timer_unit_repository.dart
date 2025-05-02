import 'package:potato_task/snapshots/timer_unit_snapshot.dart';

abstract class TimerUnitRepository {
  Future<void> saveSnapshot(TimerUnitSnapshot snapshot);
  Future<TimerUnitSnapshot?>  loadSnapshot(String uuid);
}