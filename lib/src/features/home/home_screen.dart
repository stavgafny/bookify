import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../booking_card/booking_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = BookingModel(
      id: 1,
      name: "Hotel",
      checkinDate: DateTime.now(),
      checkoutDate: DateTime.now().add(const Duration(days: 3)),
      lastDateToCancel: DateTime.now().add(const Duration(days: 5)),
      startRoomPrice: 430,
      priceNotifier: 300,
      lastPrice: 120,
      lastUpdateDate: DateTime.now().subtract(const Duration(minutes: 1)),
    );
    return Scaffold(
      body: Center(
        child: BookingCard(booking: booking, subscribed: true),
      ),
    );
  }
}
