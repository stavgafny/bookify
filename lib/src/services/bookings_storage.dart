import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';
import '../utils/bookings_converter.dart';
import '../utils/logger.dart';

class BookingsStorage {
  static final _logger = Logger.debugInstance?.of<BookingsStorageLogger>();

  static const String _storeKey = '\$bookings-list-store-key';
  static SharedPreferences? _prefs;

  static Future<void> _ensureEstablishAndRefresh() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.reload();
  }

  static Future<List<BookingModel>?> read() async {
    List<BookingModel>? bookings;
    String errorMessage = "";
    try {
      await _ensureEstablishAndRefresh();
      final bookingsJson = _prefs?.getString(_storeKey);
      if (bookingsJson == null) throw Exception("NO SAVED BOOKINGS FOUND");
      bookings = BookingsConverter.decode(bookingsJson);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _logger?.logRead(bookings: bookings, errorMessage: errorMessage);
    }
    return bookings;
  }

  static Future<bool> store(List<BookingModel> bookings) async {
    await _ensureEstablishAndRefresh();
    final stored = await _prefs?.setString(
            _storeKey, BookingsConverter.encode(bookings)) ??
        false;

    _logger?.logStore(stored: stored, bookings: bookings);
    return stored;
  }
}
