import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../providers/bookings_data_provider.dart';

class BookingsBackgroundWorker {
  static const String _isolatePortName = 'bookings-background-worker[@isolate]';
  static const int _isolateId = 10;

  static final ReceivePort _receivePort = ReceivePort();
  static SendPort? _sendPort;

  static void Function()? _update;

  static void onUpdate(void Function() callback) {
    _update = callback;
  }

  static void _sendToUI() {
    print("SENDING UI CHANGES");
    _sendPort ??= IsolateNameServer.lookupPortByName(_isolatePortName);
    _sendPort?.send(null);
  }

  @pragma('vm:entry-point')
  static Future<void> _worker() async {
    print("CALLED WORKER");
    BookingsDataProvider.updateBookingsData(
      onChangedBookings: _sendToUI,
      onPriceAlerts: (bookings) {
        print("PRICE ALERTS ON ${bookings.length} bookings");
      },
    );
  }

  static Future<void> instantiateWorker({required Duration duration}) async {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _isolatePortName,
    );

    _receivePort.listen((_) => _update?.call());

    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.oneShot(
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
