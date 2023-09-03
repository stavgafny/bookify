import 'package:flutter/material.dart';
import '../../../services/bookings_last_cancellation_date.dart';
import '../../../utils/date_formatter.dart';
import '../../../utils/time_helper.dart';

class LastDateToCancelText extends StatefulWidget {
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
  State<LastDateToCancelText> createState() => _LastDateToCancelTextState();
}

class _LastDateToCancelTextState extends State<LastDateToCancelText> {
  @override
  Widget build(BuildContext context) {
    final deadline = _getDeadline();
    final color = _getColor(deadline);

    _setNextUpdateTime(deadline.duration);
    return Expanded(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: color.withAlpha(LastDateToCancelText._bgAplha),
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

  void _setNextUpdateTime(Duration duration) {
    final time = TimeHelper.getNextUpdate(duration, secondary: true);
    Future.delayed(time, () => setState(() {}));
  }

  Widget _dateText({required Color color}) {
    final dateText = DateFormatter.formatDate(widget.lastDateToCancel);
    return Text(
      "Cancellation date: $dateText",
      style: LastDateToCancelText._baseTextStyle.copyWith(color: color),
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
      style: LastDateToCancelText._baseTextStyle
          .copyWith(fontWeight: FontWeight.w700, color: color),
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
      lastDateToCancel: widget.lastDateToCancel,
      time: DateTime.now(),
    );
  }
}
