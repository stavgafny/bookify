import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';

class LastCancellationDeadline {
  final Duration duration;
  final bool reachedReminderDuration;

  const LastCancellationDeadline(this.duration, this.reachedReminderDuration);

  bool get isAfter => duration.isNegative;
}

class BookingsLastCancellationDate {
  static const _reminderDuration = Duration(days: 2);

  static LastCancellationDeadline getDeadline({
    required DateTime lastDateToCancel,
    required DateTime time,
  }) {
    final duration = lastDateToCancel.difference(time);
    return LastCancellationDeadline(
      duration,
      duration < _reminderDuration && !duration.isNegative,
    );
  }

  /// Returns given list of bookings in which their last date to cancel is less
  /// then [_reminderDuration] and the first time its less since last timestamp
  static Future<List<BookingModel>> getRemindingBookings(
      List<BookingModel> bookings) async {
    final timeStamp =
        await _BookingsReminderTimeStampHandler.markNewTimeStamp();
    final remindingBookings = <BookingModel>[];
    for (final booking in bookings) {
      final remindingBooking = _justReachedRemindingDuration(
        lastDateToCancel: booking.lastDateToCancel,
        timeStamp: timeStamp,
      );

      if (remindingBooking) {
        remindingBookings.add(booking);
      }
    }

    return remindingBookings;
  }

  static bool _justReachedRemindingDuration({
    required DateTime lastDateToCancel,
    required _BookingsReminderTimeStamp timeStamp,
  }) {
    final reachedCurrent = getDeadline(
      lastDateToCancel: lastDateToCancel,
      time: timeStamp.curernt,
    ).reachedReminderDuration;

    final reachedPrevious = timeStamp.previous != null &&
        getDeadline(
          lastDateToCancel: lastDateToCancel,
          time: timeStamp.previous!,
        ).reachedReminderDuration;

    return reachedCurrent && !reachedPrevious;
  }
}

class _BookingsReminderTimeStampHandler {
  static const String _storeKey = '\$bookings-reminder-time-stamp';
  static SharedPreferences? _prefs;

  static Future<void> _ensureEstablishAndRefresh() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.reload();
  }

  static Future<DateTime?> _readTimeStamp() async {
    await _ensureEstablishAndRefresh();
    try {
      final timeStampMil = _prefs?.getInt(_storeKey);
      return DateTime.fromMillisecondsSinceEpoch(timeStampMil!);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> _storeTimeStamp(DateTime time) async {
    await _ensureEstablishAndRefresh();
    return await _prefs?.setInt(_storeKey, time.millisecondsSinceEpoch) ??
        false;
  }

  static Future<_BookingsReminderTimeStamp> markNewTimeStamp() async {
    final timeStamp = await _readTimeStamp();
    final now = DateTime.now();
    await _storeTimeStamp(now);
    return _BookingsReminderTimeStamp(timeStamp, now);
  }
}

class _BookingsReminderTimeStamp {
  final DateTime? previous;
  final DateTime curernt;
  const _BookingsReminderTimeStamp(this.previous, this.curernt);
}
