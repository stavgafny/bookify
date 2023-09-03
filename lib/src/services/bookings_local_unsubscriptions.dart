import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookings_unsubscriptions.dart';

class BookingsLocalUnsubscriptions {
  static const String _storeKey = '\$bookings-local-subscriptions';
  static SharedPreferences? _prefs;
  static Future<void> _ensureEstablishAndRefresh() async {
    _prefs ??= await SharedPreferences.getInstance();

    //! No need since only main isolate uses this service
    // await _prefs?.reload();
  }

  static Future<BookingsUnsubscriptions?> readUnsubscriptions() async {
    await _ensureEstablishAndRefresh();
    try {
      final unsubscriptions = _prefs?.getStringList(_storeKey);
      if (unsubscriptions == null) throw Exception("NO UNSUBSCRIPTIONS FOUND");
      return BookingsUnsubscriptions.fromList(unsubscriptions);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> storeUnsubscriptions(
    BookingsUnsubscriptions unsubscriptions,
  ) async {
    await _ensureEstablishAndRefresh();
    return await _prefs?.setStringList(_storeKey, unsubscriptions.toList()) ??
        false;
  }

  static Future<bool> updateBooking(String id, bool subscribed) async {
    final unsubscriptions = await readUnsubscriptions();
    if (unsubscriptions == null) return false;
    unsubscriptions.setId(id, subscribed);
    return await storeUnsubscriptions(unsubscriptions);
  }
}
