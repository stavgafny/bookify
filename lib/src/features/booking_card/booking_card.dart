import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import './widgets/name_title.dart';
import './widgets/dates_text.dart';
import './widgets/price_notifier.dart';
import './widgets/last_price.dart';
import './widgets/subscription_button.dart';
import './widgets/last_update_date.dart';
import './widgets/last_date_to_cancel_text.dart';

class BookingCard extends StatelessWidget {
  static const _cardBgColor = Color(0xFF312E39);
  static const _cardHeight = 100.0;

  final BookingModel booking;
  final bool subscribed;

  const BookingCard({
    required this.booking,
    required this.subscribed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: _cardHeight,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _cardBgColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF101010),
              offset: Offset(0.0, 4.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _mainContent(),
                  _prices(),
                ],
              ),
            ),
            const VerticalDivider(),
            _notificationAndLastUpdate(),
          ],
        ),
      ),
    );
  }

  Widget _mainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NameTitle(text: booking.name),
        DatesText(
          checkinDate: booking.checkinDate,
          checkoutDate: booking.checkoutDate,
        ),
        LastDateToCancelText(lastDateToCancel: booking.lastDateToCancel),
      ],
    );
  }

  Widget _prices() {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PriceNotifier(priceNotifier: booking.priceNotifier),
            LastPrice(
              lastPrice: booking.lastPrice,
              priceNotifier: booking.priceNotifier,
            )
          ],
        ),
      ),
    );
  }

  Widget _notificationAndLastUpdate() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SubscriptionButton(
          id: booking.id,
          initialSubscription: subscribed,
          lastDateToCancel: booking.lastDateToCancel,
        ),
        LastUpdateDate(lastUpdateDate: booking.lastUpdateDate),
      ],
    );
  }
}
