import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';

class BookingsConverter {
  static String encode(List<BookingModel> bookings) {
    try {
      return json.encode(bookings.map((booking) => booking.toJson()).toList());
    } catch (e) {
      return "";
    }
  }

  static List<BookingModel> decode(String bookingsJson) {
    try {
      return (json.decode(bookingsJson) as List<dynamic>)
          .map((bookingJson) => BookingModel.fromJson(bookingJson))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static List<BookingModel> tryParse(String bookingsJson) {
    final List<dynamic> bookingsMaps = json.decode(bookingsJson);
    final List<BookingModel> bookings = [];
    for (var bookingMap in bookingsMaps) {
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
}
