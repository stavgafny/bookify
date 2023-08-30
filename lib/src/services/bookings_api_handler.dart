import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import '../utils/bookings_converter.dart';
import '../utils/logger.dart';

class BookingsApiHandler {
  static final _logger = Logger.debugInstance?.of<BookingsApiLogger>();

  static final _url = Uri.http(
    // 'booking-bot.bounceme.net',
    '192.168.68.103:8077',
    'api/hotel-listeners',
  );
  static const _headers = {"Content-Type": "application/json"};
  static const _timeLimit = Duration(seconds: 5);

  static Future<List<BookingModel>?> fetchBookings() async {
    List<BookingModel>? bookings;
    String errorMessage = "";
    try {
      final response =
          await http.read(_url, headers: _headers).timeout(_timeLimit);
      bookings = BookingsConverter.tryParse(response);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _logger?.logFetch(bookings: bookings, errorMessage: errorMessage);
    }
    return bookings;
  }
}
