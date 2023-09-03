import 'package:flutter/material.dart';
import '../../../services/bookings_last_cancellation_date.dart';
import '../../../utils/date_formatter.dart';

class LastDateToCancelText extends StatelessWidget {
  static const _baseTextStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
  );
  static const _bgAplha = 30;

  final DateTime lastDateToCancel;
  const LastDateToCancelText({
    required this.lastDateToCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deadline = _getDeadline();
    final color = _getColor(deadline);
    return Expanded(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: color.withAlpha(_bgAplha),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dateText(color: color),
              const SizedBox(width: 2.0),
              _deadlineText(deadline: deadline, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateText({required Color color}) {
    final dateText = DateFormatter.formatDate(lastDateToCancel);
    return Text(
      "Cancellation date: $dateText",
      style: _baseTextStyle.copyWith(color: color),
    );
  }

  Widget _deadlineText({
    required LastCancellationDeadline deadline,
    required Color color,
  }) {
    final deadlineText = DateFormatter.formatDuration(
      deadline.duration,
      secondary: true,
    );
    return Text(
      "($deadlineText)",
      style: _baseTextStyle.copyWith(fontWeight: FontWeight.w700, color: color),
    );
  }

  Color _getColor(LastCancellationDeadline deadline) {
    final isNegative = deadline.duration.isNegative;
    Color color = Colors.white;
    if (deadline.reachedReminderDuration || isNegative) {
      color = isNegative ? Colors.black : Colors.amber;
    }
    return color;
  }

  LastCancellationDeadline _getDeadline() {
    return BookingsLastCancellationDate.getDeadline(
      lastDateToCancel: lastDateToCancel,
      time: DateTime.now(),
    );
  }
}
