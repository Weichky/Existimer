//timer_manager.dart
class TimeManager {
  static final TimeManager _instance = TimeManager._internal();

  int _timeDrift = 0;
  int _timezoneOffset = 0;

  TimeManager._internal();

  factory TimeManager() => _instance;

  DateTime get currentTime {
    DateTime now = DateTime.now().add(Duration(milliseconds: _timeDrift));
    return now.add(Duration(hours: _timezoneOffset));
  }

  void setTimeDrift(int milliseconds) {
    _timeDrift = milliseconds;
  }

  void setTimezoneOffset(int hours) {
    _timezoneOffset = hours;
  }

  void reset() {
    _timeDrift = 0;
    _timezoneOffset = 0;
  }
}