import '../models/bookings_data.dart';
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
      print("fetched ${bookingsData.bookings?.length.toString()} bookings");
      BookingsStorage.store(bookingsData.bookings ?? []);
    }
    return bookingsData;
  }
}
