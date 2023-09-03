class DateFormatter {
  static String formatDate(DateTime date, {bool shortenYear = false}) {
    return [
      "${date.day}",
      "${date.month}",
      shortenYear ? "${date.year}".substring(2) : "${date.year}",
    ].map((e) => e.padLeft(2, '0')).join("/");
  }

  static String formatDuration(Duration duration, {bool secondary = false}) {
    final charge = duration.isNegative ? -1 : 1;
    duration = duration.abs();

    final days = duration.inDays * charge;
    final hours = duration.inHours % Duration.hoursPerDay * charge;
    final minutes = duration.inMinutes % Duration.minutesPerHour * charge;
    final seconds = duration.inSeconds % Duration.secondsPerMinute * charge;

    final timeFormats = <String>[];

    if (days.abs() > 0) timeFormats.add("${days}d");
    if (hours.abs() > 0) timeFormats.add("${hours}h");
    if (minutes.abs() > 0) timeFormats.add("${minutes}m");
    timeFormats.add("${seconds}s");

    return timeFormats.first +
        (secondary && timeFormats.length > 1 ? (" ${timeFormats[1]}") : "");
  }
}
