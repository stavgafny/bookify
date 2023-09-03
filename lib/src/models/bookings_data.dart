import './booking_model.dart';
import './bookings_unsubscriptions.dart';

enum BookingsDataRetrievalStatus { fetch, read, fail }

class BookingsData {
  static Future<BookingsData> Function() generateFromRetrievalMethod({
    required Future<List<BookingModel>?> Function() method,
    required BookingsDataRetrievalStatus status,
  }) {
    return () async {
      final bookings = await method();
      return BookingsData(
        bookings: bookings,
        status: bookings != null ? status : BookingsDataRetrievalStatus.fail,
      );
    };
  }

  final List<BookingModel>? bookings;
  final BookingsDataRetrievalStatus status;
  final bool usedFallback;
  final BookingsUnsubscriptions unsubscriptions;

  const BookingsData({
    required this.bookings,
    required this.status,
    this.usedFallback = false,
    this.unsubscriptions = BookingsUnsubscriptions.empty,
  });

  bool get failed => status == BookingsDataRetrievalStatus.fail;
  bool get succeeded => !failed;

  BookingsData asFallback() {
    return BookingsData(bookings: bookings, status: status, usedFallback: true);
  }

  BookingsData copyWith({
    List<BookingModel>? bookings,
    BookingsDataRetrievalStatus? status,
    bool? usedFallback,
    BookingsUnsubscriptions? unsubscriptions,
  }) {
    return BookingsData(
      bookings: bookings ?? this.bookings,
      status: status ?? this.status,
      usedFallback: usedFallback ?? this.usedFallback,
      unsubscriptions: unsubscriptions ?? this.unsubscriptions,
    );
  }
}
