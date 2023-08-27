import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../services/bookings_api_handler.dart';

class BookingsBackgroundWorker {
  static const String _isolatePortName = 'bookings-background-worker[@isolate]';
  static const int _isolateId = 10;
  static SendPort? _sendPort;
  static final ReceivePort _receivePort = ReceivePort();

  @pragma('vm:entry-point')
  static Future<void> _worker() async {
    final bookings = await BookingsApiHandler.fetchBookings();

    // This will be null if running in the background.
    _sendPort ??= IsolateNameServer.lookupPortByName(_isolatePortName);
    _sendPort?.send(null);
  }

  static Future<void> instantiateWorker({required Duration duration}) async {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _isolatePortName,
    );
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
  }
}
