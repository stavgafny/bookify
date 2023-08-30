import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../models/bookings_data.dart';

class Logger {
  static Logger? _debugInstace;

  factory Logger._getDebugInstance() {
    _debugInstace ??= const Logger._();
    return _debugInstace!;
  }

  static Logger? get debugInstance {
    return kDebugMode ? Logger._getDebugInstance() : null;
  }

  const Logger._();

  T of<T extends LoggerMethods>() {
    final loggerInstance = _loggerInstances[T];
    if (loggerInstance != null) {
      return loggerInstance as T;
    }
    throw Exception(
      "Unsupported logger type. Make sure all loggers are initialized",
    );
  }

  static final _loggerInstances = <Type, LoggerMethods>{
    BookingsStorageLogger: BookingsStorageLogger(),
    BookingsApiLogger: BookingsApiLogger(),
    BookingsBGWorkerLogger: BookingsBGWorkerLogger(),
    BookingsDataProviderLogger: BookingsDataProviderLogger(),
  };
  static final Map<String, bool> _disabled = [
    //* All disabled loggers are initialized here for all isolates
  ].asMap().map((key, value) => MapEntry(value.toString(), true));
}

abstract class LoggerMethods {
  final String _name;
  const LoggerMethods(this._name);

  Function? get _logGaurd {
    final disabled = Logger._disabled[_name] ?? false;
    return disabled ? null : developer.log;
  }

  void log(String text) => _logGaurd?.call(text, name: _name);
  void error(String text) => _logGaurd?.call("", error: text, name: _name);
}

class BookingsStorageLogger extends LoggerMethods {
  BookingsStorageLogger() : super("BookingsStorageLogger");

  void logRead({required List<BookingModel>? bookings, Object? errorMessage}) {
    if (bookings == null) {
      error("failed to read bookings $errorMessage");
    } else {
      log("read ${bookings.length} bookings");
    }
  }

  void logStore({required bool stored, required List<BookingModel> bookings}) {
    if (stored) {
      log("stored ${bookings.length} bookings");
    } else {
      error("failed to store ${bookings.length} bookings");
    }
  }
}

class BookingsApiLogger extends LoggerMethods {
  BookingsApiLogger() : super("BookingsApiLogger");

  void logFetch({required List<BookingModel>? bookings, Object? errorMessage}) {
    if (bookings == null) {
      error("failed to fetch bookings $errorMessage");
    } else {
      log("fetched ${bookings.length} bookings");
    }
  }
}

class BookingsBGWorkerLogger extends LoggerMethods {
  BookingsBGWorkerLogger() : super("BookingsBGWorkerLogger");
}

class BookingsDataProviderLogger extends LoggerMethods {
  BookingsDataProviderLogger() : super("BookingsDataProviderLogger");

  void logProvidedBookingsData({
    required BookingsData bookingsData,
    required bool preferFetch,
  }) {
    if (bookingsData.failed) {
      error("no bookings data provided - preferedFetch: $preferFetch");
    } else {
      log("provided bookings data, retrieval method: ${bookingsData.status.name} - preferedFetch: $preferFetch");
    }
  }
}
