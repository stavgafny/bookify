import 'package:flutter/material.dart';
import '../../models/bookings_data.dart';
import '../../providers/bookings_data_provider.dart';
import './widgets/bookings_loading_animation.dart';
import './widgets/bookings_error_message.dart';
import './widgets/booking_cards_list_view.dart';

class BookingCardsFeed extends StatefulWidget {
  const BookingCardsFeed({super.key});

  @override
  State<BookingCardsFeed> createState() => _BookingCardsFeedState();
}

class _BookingCardsFeedState extends State<BookingCardsFeed> {
  Future<BookingsData>? _bookingsData;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _bookingsData = BookingsDataProvider.getBookingsData(preferFetch: false);
    });
  }

  Future<void> _refreshBookings() async {
    setState(() {
      _bookingsData = BookingsDataProvider.getBookingsData(preferFetch: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: _refreshBookings,
        color: Colors.amber,
        child: FutureBuilder<BookingsData>(
          future: _bookingsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const BookingsLoadingAnimation();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return BookingsErrorMessage.internalError(snapshot.error);
            }
            final bookingsData = snapshot.data!;
            if (bookingsData.failed) {
              return BookingsErrorMessage.noBookings;
            }
            final bookings = bookingsData.bookings ?? [];
            if (bookings.isEmpty) {
              return BookingsErrorMessage.emptyBookings;
            }
            return BookingCardsListView(bookings: bookingsData.bookings!);
          },
        ),
      ),
    );
  }
}
