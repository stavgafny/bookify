import 'package:flutter/material.dart';
import '../../../services/bookings_last_cancellation_date.dart';
import '../../../services/bookings_local_unsubscriptions.dart';

class SubscriptionButton extends StatefulWidget {
  final int id;
  final bool initialSubscription;
  final DateTime lastDateToCancel;
  const SubscriptionButton({
    required this.id,
    required this.initialSubscription,
    required this.lastDateToCancel,
    super.key,
  });

  @override
  State<SubscriptionButton> createState() => _SubscriptionButtonState();
}

class _SubscriptionButtonState extends State<SubscriptionButton> {
  late bool _subscribed;

  LastCancellationDeadline _getDeadline() {
    return BookingsLastCancellationDate.getDeadline(
      lastDateToCancel: widget.lastDateToCancel,
      time: DateTime.now(),
    );
  }

  @override
  void initState() {
    _subscribed = widget.initialSubscription;
    final deadline = _getDeadline();
    if (!deadline.isAfter) {
      Future.delayed(deadline.duration, () {
        if (mounted) {
          setState(() {});
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = _getDeadline().isAfter;
    return IconButton(
      onPressed: !disabled ? _toogleSubscription : null,
      icon: Icon(
        _subscribed && !disabled
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
