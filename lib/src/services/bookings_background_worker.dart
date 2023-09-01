import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../models/booking_model.dart';
import '../providers/bookings_data_provider.dart';
import '../utils/logger.dart';
import './bookings_notifications_service.dart';

class BookingsBackgroundWorker {
  static final _logger = Logger.debugInstance?.of<BookingsBGWorkerLogger>();

  static const String _isolatePortName = 'bookings-background-worker[@isolate]';
  static const int _isolateId = 10;

  static final ReceivePort _receivePort = ReceivePort();
  static SendPort? _sendPort;

  static void Function()? _update;

  static void onUpdate(void Function() callback) {
    _update = callback;
  }

  static void _sendToUI() {
    _logger?.log("sending UI changes");
    _sendPort ??= IsolateNameServer.lookupPortByName(_isolatePortName);
    _sendPort?.send(null);
  }

  static void _notifiPriceAlerts(List<BookingModel> bookings) {
    for (final booking in bookings) {
      BookingsNotificationsService.createNotification(
        title: booking.name,
        body: "Price is now \$${booking.lastPrice}",
      );
    }
    _logger?.log("price alert changes on ${bookings.length} bookings");
  }

  static void _notifiLTTCBookings(List<BookingModel> bookings) {
    for (final booking in bookings) {
      final lttcTime = booking.lastDateToCancel.difference(DateTime.now());
      final lttcTimeInDays = (lttcTime.inHours / Duration.hoursPerDay).round();
      BookingsNotificationsService.createNotification(
        title: booking.name,
        body: "Last cancellation date is near! ($lttcTimeInDays days left)",
        reminder: true,
      );
    }
    _logger?.log("LTTC alerts on ${bookings.length} bookings");
  }

  @pragma('vm:entry-point')
  static Future<void> _worker() async {
    _logger?.log("fired scheduled worker");
    BookingsDataProvider.updateBookingsData(
      onChangedBookings: _sendToUI,
      onPriceAlerts: _notifiPriceAlerts,
      lttcAlerts: _notifiLTTCBookings,
    );
  }

  static Future<void> instantiateWorker({required Duration duration}) async {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _isolatePortName,
    );

    _receivePort.listen((_) => _update?.call());

    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(
      duration,
      _isolateId,
      _worker,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
    );

    _logger?.log("instantiated worker");
  }
}
