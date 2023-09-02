import 'package:flutter/material.dart';
import '../../../utils/date_formatter.dart';

class DatesText extends StatelessWidget {
  static const _textColor = Color(0xFFB4B4B4);
  static const _style = TextStyle(fontSize: 12.0, color: _textColor);

  final DateTime checkinDate;
  final DateTime checkoutDate;
  const DatesText({
    required this.checkinDate,
    required this.checkoutDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(DateFormatter.formatDate(checkinDate), style: _style),
        const SizedBox(
          width: 10.0,
          child: Divider(color: _textColor, indent: 1, endIndent: 1),
        ),
        Text(DateFormatter.formatDate(checkoutDate), style: _style),
      ],
    );
  }
}
