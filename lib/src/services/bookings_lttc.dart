import 'package:bookify/src/models/booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LTTCDuration {
  final Duration duration;
  final bool reachedAlertDuration;

  const LTTCDuration(this.duration, this.reachedAlertDuration);
}

/// Bookings Last Time To Cancel
class BookingsLTTC {
  /// The duration in which needs to be alerted
  static const _lttcAlertDuration = Duration(days: 2);

  static LTTCDuration getLTTCDuration(DateTime lttc, DateTime time) {
    final duration = lttc.difference(time);
    return LTTCDuration(
      duration,
      duration < _lttcAlertDuration && !duration.isNegative,
    );
  }

  /// Returns given list of bookings in which their last date to cancel is less
  /// then [lttcAlertDuration] and it is the first time it is less
  static Future<List<BookingModel>> getAlertingLTTCBookings(
    List<BookingModel> bookings,
  ) async {
    final timeStamp = await _BookingsLTTCsTimeStamp.readTimeStamp();
    final now = DateTime.now();
    await _BookingsLTTCsTimeStamp.storeTimeStamp(now);

    final alertingLTTCBookings = <BookingModel>[];

    for (final booking in bookings) {
      final lttc = booking.lastDateToCancel;

      if (_justReachedAlertDuration(lttc, now, timeStamp)) {
        alertingLTTCBookings.add(booking);
      }
    }
    return alertingLTTCBookings;
  }

  static bool _justReachedAlertDuration(
    DateTime lttc,
    DateTime now,
    DateTime? timeStamp,
  ) {
    final reachedNow = getLTTCDuration(lttc, now).reachedAlertDuration;
    final notReachedTimeStamp = timeStamp == null ||
        !getLTTCDuration(lttc, timeStamp).reachedAlertDuration;

    return reachedNow && notReachedTimeStamp;
  }
}

class _BookingsLTTCsTimeStamp {
  static const String _storeKey = '\$background-worker-time-stamp';
  static SharedPreferences? _prefs;

  static Future<void> _ensureEstablishAndRefresh() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.reload();
  }

  static Future<DateTime?> readTimeStamp() async {
    await _ensureEstablishAndRefresh();
    try {
      final timeStampMil = _prefs?.getInt(_storeKey);
      return DateTime.fromMillisecondsSinceEpoch(timeStampMil!);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> storeTimeStamp(DateTime time) async {
    await _ensureEstablishAndRefresh();
    return await _prefs?.setInt(_storeKey, time.millisecondsSinceEpoch) ??
        false;
  }
}
