import '../models/booking_model.dart';
import '../services/bookings_last_cancellation_date.dart';
import '../services/bookings_local_unsubscriptions.dart';

class BookingsListHelper {
  static BookingModel? _getBookingById(List<BookingModel> bookings, int id) {
    final ids = bookings.map((booking) => booking.id).toList();
    final index = ids.indexOf(id);
    return index == -1 ? null : bookings.elementAt(index);
  }

  /// Gets [prevBookings] [newBookings] lists.
  ///
  /// Returns all new bookings that changed from previous bookings
  /// (also applies if new booking has no corresponding previous booking)
  static List<BookingModel> getChangedBookings({
    required List<BookingModel> prevBookings,
    required List<BookingModel> newBookings,
  }) {
    final changed = <BookingModel>[];
    for (final newBooking in newBookings) {
      final prevBooking = _getBookingById(prevBookings, newBooking.id);
      if (newBooking != prevBooking) {
        changed.add(newBooking);
      }
    }
    return changed;
  }

  /// Gets [prevBookings] [newBookings] lists.
  ///
  /// Returns all new bookings that their price changed from previous
  /// (if booking has no previous, then it is also considered as changed)
  /// that are still below the `priceNotfiier` threshold and that aren't
  /// in local unsubscriptions.
  static List<BookingModel> getPriceAlerts({
    required List<BookingModel> prevBookings,
    required List<BookingModel> newBookings,
  }) {
    final changed = <BookingModel>[];
    for (final newBooking in newBookings) {
      if (newBooking.lastPrice != null &&
          newBooking.lastPrice! < newBooking.priceNotifier) {
        final prevBooking = _getBookingById(prevBookings, newBooking.id);
        if ((prevBooking == null) ||
            (prevBooking.lastPrice != newBooking.lastPrice)) {
          changed.add(newBooking);
        }
      }
    }
    return changed;
  }

  /// Valid bookings are bookings that haven't reached their cancellation
  /// deadline.
  ///* Note: ones that reached deadline reminder are valid
  static List<BookingModel> getValidBookings(List<BookingModel> bookings) {
    final now = DateTime.now();
    return bookings.where((booking) {
      final deadline = BookingsLastCancellationDate.getDeadline(
        lastDateToCancel: booking.lastDateToCancel,
        time: now,
      );
      return !deadline.isAfter;
    }).toList();
  }

  static Future<List<BookingModel>> getSubscribedOnlyBookings(
    List<BookingModel> bookings,
  ) async {
    final unsubscriptions =
        await BookingsLocalUnsubscriptions.readUnsubscriptions();
    final subscribedOnlyBookings = <BookingModel>[];
    for (final booking in bookings) {
      final isSubscribed = unsubscriptions.getIsIdSubscribed(booking.id);
      if (isSubscribed) {
        subscribedOnlyBookings.add(booking);
      }
    }
    return subscribedOnlyBookings;
  }
}
