import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as t;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class TimeZone {
  // ignore: unused_element
  TimeZone._() {
    initializeTimeZones();
  }
  factory TimeZone() => _this ?? TimeZone._();

  static TimeZone? _this;

  Future<String> getTimeZoneName() async =>
      FlutterNativeTimezone.getLocalTimezone();

  Future<t.Location> getLocation([String? timeZoneName]) async {
    if (timeZoneName == null || timeZoneName.isEmpty) {
      timeZoneName = await getTimeZoneName();
    }
    return t.getLocation(timeZoneName);
  }
}
