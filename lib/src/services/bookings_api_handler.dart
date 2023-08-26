import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';

class BookingsApiHandler {
  static final _url = Uri.http(
    // 'booking-bot.bounceme.net',
    '192.168.68.103:8077',
    'api/hotel-listeners',
  );
  static const _headers = {"Content-Type": "application/json"};

  static List<BookingModel> _parseBookingsResponse(List<dynamic> bookingsData) {
    final List<BookingModel> bookings = [];
    for (var bookingMap in bookingsData) {
      try {
        bookings.add(BookingModel.fromMap(bookingMap));
      } catch (e) {
        if (kDebugMode) {
          print("Faild to construct BookingModel $e on $bookingMap");
        }
      }
    }
    return bookings;
  }

  static Future<List<BookingModel>?> fetchBookings() async {
    try {
      final response = await http.read(_url, headers: _headers);
      final List<dynamic> bookingsData = json.decode(response);
      final bookings = _parseBookingsResponse(bookingsData);
      return bookings;
    } catch (e) {
      return null;
    }
  }
}
