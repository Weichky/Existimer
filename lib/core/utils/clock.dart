//clock.dart
class Clock {
  static final Clock _instance = Clock._internal();

  int _timeDrift = 0;
  int _timezoneOffset = 0;

  Clock._internal();

  factory Clock() => _instance;

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