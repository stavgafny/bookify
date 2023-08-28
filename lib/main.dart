import 'package:flutter/material.dart';
import './src/configs/app_config.dart';
import './src/main_app.dart';
import './src/services/bookings_background_worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appConfig.init();
  runApp(const MainApp());

  await BookingsBackgroundWorker.instantiateWorker(
    duration: const Duration(seconds: 10),
  );
}
