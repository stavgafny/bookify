import 'package:flutter/material.dart';
import '../booking_cards_feed/booking_cards_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: BookingCardsFeed(),
      ),
    );
  }
}
