class DateFormatter {
  static String formatDate(DateTime date, {bool shortenYear = false}) {
    return [
      "${date.day}",
      "${date.month}",
      shortenYear ? "${date.year}".substring(2) : "${date.year}",
    ].map((e) => e.padLeft(2, '0')).join("/");
  }

  static String formatDuration(Duration duration, {bool secondary = false}) {
    final days = duration.inDays;
    final hours = duration.inHours % Duration.hoursPerDay;
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    final seconds = duration.inSeconds % Duration.secondsPerMinute;

    final timeFormats = <String>[];

    if (days.abs() > 0) timeFormats.add("${days}d");
    if (hours.abs() > 0) timeFormats.add("${hours}h");
    if (minutes.abs() > 0) timeFormats.add("${minutes}m");
    timeFormats.add("${seconds}s");

    return timeFormats.first + (secondary ? (" ${timeFormats[1]}") : "");
  }
}
