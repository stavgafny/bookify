class DateFormatter {
  static String formatDuration(Duration duration, {bool secondary = false}) {
    final timeFormats = <String>[];
    final days = duration.inDays;
    final hours = duration.inHours % Duration.hoursPerDay;
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    final seconds = duration.inSeconds % Duration.secondsPerMinute;

    if (days.abs() > 0) timeFormats.add("${days}d");
    if (hours.abs() > 0) timeFormats.add("${hours}h");
    if (minutes.abs() > 0) timeFormats.add("${minutes}m");
    timeFormats.add("${seconds}s");

    return timeFormats.first + (secondary ? (" ${timeFormats[1]}") : "");
  }

  static String formatDate(DateTime date, {bool shortenYear = false}) {
    return [
      "${date.day}",
      "${date.month}",
      shortenYear ? "${date.year}".substring(2) : "${date.year}",
    ].map((e) => e.padLeft(2, '0')).join("/");
  }
}

/*
  static int getApproximateDaysLeft(Duration duration) {
    return (duration.inHours / Duration.hoursPerDay).round();
  }

  static int getApproximateHoursLeft(Duration duration) {
    return (duration.inMinutes / Duration.minutesPerHour).round();
  }

  static String getFormattedApproximateTimeLeft(Duration duration) {
    int time = getApproximateDaysLeft(duration);
    if (time > 0 || (time < 0 && duration.isNegative)) {
      return "${time}d";
    }
    time = getApproximateHoursLeft(duration);
    return "${time}h";
  }
*/
