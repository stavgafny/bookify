import 'package:flutter/material.dart';

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

  String dateToString(DateTime time) {
    return [
      "${time.day}".padLeft(2, '0'),
      "${time.month}".padLeft(2, '0'),
      "${time.year}".substring(2),
    ].join("/");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(dateToString(checkinDate), style: _style),
        const SizedBox(
          width: 10.0,
          child: Divider(color: _textColor, indent: 1, endIndent: 1),
        ),
        Text(dateToString(checkoutDate), style: _style),
      ],
    );
  }
}
