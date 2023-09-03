class TimeHelper {
  static Duration getNextUpdate(Duration duration, {bool secondary = false}) {
    final days = duration.inDays;
    final hours = duration.inHours % Duration.hoursPerDay;
    final minutes = duration.inMinutes % Duration.minutesPerHour;

    final timeFactors = <int>[];

    if (days.abs() > 0) timeFactors.add(Duration.microsecondsPerDay);
    if (hours.abs() > 0) timeFactors.add(Duration.microsecondsPerHour);
    if (minutes.abs() > 0) timeFactors.add(Duration.microsecondsPerMinute);
    timeFactors.add(Duration.microsecondsPerSecond);

    final timeFactor = secondary ? timeFactors[1] : timeFactors.first;
    return Duration(microseconds: duration.inMicroseconds % timeFactor);
  }
}
