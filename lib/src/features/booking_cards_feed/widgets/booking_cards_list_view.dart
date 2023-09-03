import 'package:flutter/material.dart';
import '../../../models/booking_model.dart';
import '../../../models/bookings_unsubscriptions.dart';
import '../../booking_card/booking_card.dart';

class BookingCardsListView extends StatelessWidget {
  final List<BookingModel> bookings;
  final BookingsUnsubscriptions unsubscriptions;
  const BookingCardsListView({
    required this.bookings,
    required this.unsubscriptions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(
          booking: booking,
          subscribed: unsubscriptions.getStateOfId(booking.id),
        );
      },
    );
  }
}
