import '../models/bookings_data.dart';
import '../services/bookings_api_handler.dart';
import '../services/bookings_storage.dart';

class BookingsDataProvider {
  static final _fetchBookingsData = BookingsData.generateFromRetrieval(
    method: BookingsApiHandler.fetchBookings,
    successStatus: BookingsDataRetrievalStatus.fetch,
  );

  static final _readBookingsData = BookingsData.generateFromRetrieval(
    method: BookingsStorage.read,
    successStatus: BookingsDataRetrievalStatus.read,
  );

  static Future<BookingsData> _retrieveBookingsData({
    required Future<BookingsData> Function() mainMethod,
    required Future<BookingsData> Function() fallbackMethod,
  }) async {
    final mainBookingsData = await mainMethod();
    if (mainBookingsData.succeeded) {
      return mainBookingsData;
    }
    return await fallbackMethod();
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
    print(bookingsData.status);
    return bookingsData;
  }
}
