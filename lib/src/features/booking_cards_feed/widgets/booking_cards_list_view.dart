import 'package:flutter/material.dart';
import '../../../models/booking_model.dart';
import '../../booking_card/booking_card.dart';

class BookingCardsListView extends StatelessWidget {
  final List<BookingModel> bookings;
  const BookingCardsListView({required this.bookings, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: bookings[index], subscribed: true);
      },
    );
  }
}
