import '../models/booking_model.dart';
import '../models/bookings_data.dart';
import '../services/bookings_last_cancellation_date.dart';
import '../services/bookings_local_unsubscriptions.dart';
import '../utils/bookings_list_helper.dart';
import '../utils/logger.dart';
import '../services/bookings_api_handler.dart';
import '../services/bookings_storage.dart';

class BookingsDataProvider {
  static final _logger = Logger.debugInstance?.of<BookingsDataProviderLogger>();

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

    _logger?.logProvidedBookingsData(
      bookingsData: bookingsData,
      preferFetch: preferFetch,
    );

    if (bookingsData.status == BookingsDataRetrievalStatus.fetch) {
      BookingsStorage.store(bookingsData.bookings ?? []);
    }

    final unsubscriptions =
        await BookingsLocalUnsubscriptions.readUnsubscriptions();
    return bookingsData.copyWith(unsubscriptions: unsubscriptions);
  }

  static void updateBookingsData({
    required void Function() onBookingsChanges,
    required void Function(List<BookingModel> bookings) priceAlertingBookings,
    required void Function(List<BookingModel> bookings)
        cancellationDateRemindingBookings,
  }) async {
    final fetchBookingsData = await _fetchBookingsData();
    if (fetchBookingsData.failed) return;

    final readBookingsData = await _readBookingsData();

    final prevBookings = readBookingsData.bookings ?? [];
    final newBookings = fetchBookingsData.bookings ?? [];

    final changedBookings = BookingsListHelper.getChangedBookings(
      prevBookings: prevBookings,
      newBookings: newBookings,
    );

    final validNewBookings = BookingsListHelper.getValidBookings(newBookings);
    final validSubscribedOnlyNewBookings =
        await BookingsListHelper.getSubscribedOnlyBookings(validNewBookings);

    if (changedBookings.isNotEmpty) {
      await BookingsStorage.store(newBookings);
      onBookingsChanges();

      final priceAlerts = BookingsListHelper.getPriceAlerts(
        prevBookings: prevBookings,
        newBookings: validSubscribedOnlyNewBookings,
      );
      if (priceAlerts.isNotEmpty) {
        priceAlertingBookings(priceAlerts);
      }
    }
    BookingsLastCancellationDate.getRemindingBookings(
            validSubscribedOnlyNewBookings)
        .then(cancellationDateRemindingBookings);
  }
}
