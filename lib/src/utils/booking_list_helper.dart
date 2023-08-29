import '../models/booking_model.dart';

class BookingListHelper {
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
  /// and that also are still below the `priceNotfiier` threshold.
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
}
