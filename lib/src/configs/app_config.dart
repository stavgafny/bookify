import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _AppConfig {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Hides top and bottom status bars, display overlay on screen tap
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

    // Sets phone status bar and navigation bar color to transparant
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}

final appConfig = _AppConfig();
