import '../models/booking_model.dart';
import '../models/bookings_data.dart';
import '../utils/booking_list_helper.dart';
import '../services/bookings_api_handler.dart';
import '../services/bookings_storage.dart';

class BookingsDataProvider {
  static final _fetchBookingsData = BookingsData.generateFromRetrievalMethod(
    method: BookingsApiHandler.fetchBookings,
    status: BookingsDataRetrievalStatus.fetch,
  );

  static final _readBookingsData = BookingsData.generateFromRetrievalMethod(
    method: BookingsStorage.read,
    status: BookingsDataRetrievalStatus.read,
  );

  static Future<BookingsData> _retrieveBookingsData({
    required Future<BookingsData> Function() mainMethod,
    required Future<BookingsData> Function() fallbackMethod,
  }) async {
    final mainBookingsData = await mainMethod();
    if (mainBookingsData.succeeded) {
      return mainBookingsData;
    }
    return (await fallbackMethod()).asFallback();
  }

  static Future<BookingsData> getBookingsData(
      {required bool preferFetch}) async {
    final bookingsData = preferFetch
        ? await _retrieveBookingsData(
            mainMethod: _fetchBookingsData,
            fallbackMethod: _readBookingsData,
          )
        : await _retrieveBookingsData(
            mainMethod: _readBookingsData,
            fallbackMethod: _fetchBookingsData,
          );

    if (bookingsData.status == BookingsDataRetrievalStatus.fetch) {
      BookingsStorage.store(bookingsData.bookings ?? []);
    }
    return bookingsData;
  }

  static void updateBookingsData({
    required void Function() onChangedBookings,
    required void Function(List<BookingModel> bookings) onPriceAlerts,
  }) async {
    final fetchBookingsData = await _fetchBookingsData();
    if (fetchBookingsData.failed) return;

    final readBookingsData = await _readBookingsData();

    final prevBookings = readBookingsData.bookings ?? [];
    final newBookings = fetchBookingsData.bookings ?? [];

    final changedBookings = BookingListHelper.getChangedBookings(
      prevBookings: prevBookings,
      newBookings: newBookings,
    );

    if (changedBookings.isNotEmpty) {
      await BookingsStorage.store(newBookings);
      onChangedBookings();

      final priceAlerts = BookingListHelper.getPriceAlerts(
        prevBookings: prevBookings,
        newBookings: changedBookings,
      );
      if (priceAlerts.isNotEmpty) {
        onPriceAlerts(priceAlerts);
      }
    }
  }
}
