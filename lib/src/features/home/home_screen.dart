import 'package:flutter/material.dart';
import '../booking_cards_list_view/booking_cards_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: BookingCardsListView(),
      ),
    );
  }
}
