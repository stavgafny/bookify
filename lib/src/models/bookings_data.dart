import './booking_model.dart';

enum BookingsDataRetrievalStatus { fetch, read, fail }

class BookingsData {
  static Future<BookingsData> Function() generateFromRetrieval({
    required Future<List<BookingModel>?> Function() method,
    required BookingsDataRetrievalStatus successStatus,
  }) {
    return () async {
      final bookings = await method();
      return BookingsData(
          bookings: bookings,
          status: bookings != null
              ? successStatus
              : BookingsDataRetrievalStatus.fail);
    };
  }

  final List<BookingModel>? bookings;
  final BookingsDataRetrievalStatus status;

  const BookingsData({required this.bookings, required this.status});

  bool get failed => status == BookingsDataRetrievalStatus.fail;
  bool get succeeded => !failed;
}
