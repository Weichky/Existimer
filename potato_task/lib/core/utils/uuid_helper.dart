import 'package:uuid/uuid.dart';

class UuidHelper {
  static String getUuid() {
    final Uuid uuid = Uuid();
    return uuid.v4();
  }
}