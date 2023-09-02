import 'package:flutter/material.dart';
import '../../../services/bookings_lttc.dart';
import '../../../utils/date_formatter.dart';

class LastDateToCancelText extends StatelessWidget {
  static const _baseTextStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  final DateTime lttcDate;
  const LastDateToCancelText({
    required this.lttcDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lttcDuration = BookingsLTTC.getLTTCDuration(lttcDate, DateTime.now());
    final isNegative = lttcDuration.duration.isNegative;
    final timeLeftText = DateFormatter.formatDuration(lttcDuration.duration);

    Color color = Colors.white;
    if (lttcDuration.reachedAlertDuration || isNegative) {
      color = isNegative ? Colors.red : Colors.amber;
    }

    final formattedLTTC = DateFormatter.formatDate(lttcDate);
    return Expanded(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "Cancellation date: $formattedLTTC ($timeLeftText)",
          style: _baseTextStyle.copyWith(color: color),
        ),
      ),
    );
  }
}
