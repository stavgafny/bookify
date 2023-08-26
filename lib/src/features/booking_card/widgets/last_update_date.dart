import 'package:flutter/material.dart';

class LastUpdateDate extends StatelessWidget {
  static const _style = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Color(0xFF939393),
  );

  final DateTime lastUpdateDate;

  const LastUpdateDate({required this.lastUpdateDate, super.key});

  @override
  Widget build(BuildContext context) {
    return Text("~${_getCurrentTimeText()}", style: LastUpdateDate._style);
  }

  Duration get _duration => DateTime.now().difference(lastUpdateDate);

  String _getCurrentTimeText() {
    final duration = _duration;
    if (duration.inDays > 0) return "${duration.inDays}d";
    if (duration.inHours > 0) return "${duration.inHours}h";
    if (duration.inMinutes > 0) return "${duration.inMinutes}m";
    return "${duration.inSeconds}s";
  }
}
