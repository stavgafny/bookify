import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';
import '../utils/bookings_converter.dart';

class BookingsStorage {
  static const String _storeKey = '\$bookings-list-store-key';
  static SharedPreferences? _prefs;

  static Future<void> _refresh() async => await _prefs?.reload();

  static Future<void> ensureInit() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _refresh();
  }

  static Future<List<BookingModel>?> read() async {
    await ensureInit();
    final bookingsJson = _prefs?.getString(_storeKey);
    if (bookingsJson == null) return null;
    return BookingsConverter.decode(bookingsJson);
  }

  static Future<bool> store(List<BookingModel> bookings) async {
    await ensureInit();
    return await _prefs?.setString(
            _storeKey, BookingsConverter.encode(bookings)) ??
        false;
  }
}
