import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  final bool subscribed;
  const NotificationButton({required this.subscribed, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      subscribed
          ? Icons.notifications_outlined
          : Icons.notifications_off_outlined,
      size: 32.0,
    );
  }
}
