import 'package:flutter/material.dart';
import './src/configs/app_config.dart';
import './src/services/bookings_background_worker.dart';
import './src/services/bookings_notifications_service.dart';
import './src/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appConfig.init();
  await BookingsNotificationsService.init();

  runApp(const MainApp());

  await BookingsBackgroundWorker.instantiateWorker(
    duration: const Duration(minutes: 20),
  );
}
