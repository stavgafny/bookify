import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../services/bookings_api_handler.dart';
import '../../features/booking_card/booking_card.dart';

class BookingCardsListView extends StatelessWidget {
  const BookingCardsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingModel>?>(
      future: BookingsApiHandler.fetchBookings(),
      builder: (context, snapshot) {
        final bookings = snapshot.data ?? [];
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return BookingCard(booking: bookings[index], subscribed: true);
          },
        );
      },
    );
  }
}
