import 'package:flutter/material.dart';
import '../../../services/bookings_local_unsubscriptions.dart';

class SubscriptionButton extends StatefulWidget {
  final int id;
  final bool initialSubscription;
  const SubscriptionButton({
    required this.id,
    required this.initialSubscription,
    super.key,
  });

  @override
  State<SubscriptionButton> createState() => _SubscriptionButtonState();
}

class _SubscriptionButtonState extends State<SubscriptionButton> {
  late bool _subscribed;

  @override
  void initState() {
    _subscribed = widget.initialSubscription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toogleSubscription,
      icon: Icon(
        _subscribed
            ? Icons.notifications_outlined
            : Icons.notifications_off_outlined,
        size: 32.0,
      ),
    );
  }

  void _toogleSubscription() async {
    _subscribed = !_subscribed;

    await BookingsLocalUnsubscriptions.updateBooking(
      widget.id.toString(),
      _subscribed,
    );

    if (mounted) {
      setState(() {});
    }
  }
}
