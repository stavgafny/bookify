import 'dart:async';

import 'package:flutter/material.dart';
import '../../../providers/global_time.dart';

class LastUpdateDate extends StatefulWidget {
  static const _style = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Color(0xFF939393),
  );

  final DateTime lastUpdateDate;
  const LastUpdateDate({required this.lastUpdateDate, super.key});

  @override
  State<LastUpdateDate> createState() => _LastUpdateDateState();
}

class _LastUpdateDateState extends State<LastUpdateDate> {
  String _timeText = "";
  StreamSubscription<void>? _listener;

  @override
  void initState() {
    super.initState();
    _updateTextIfNeeded();
    _listener = GlobalTime.onEverySecond.listen((_) => _updateTextIfNeeded());
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  void _updateTextIfNeeded() {
    final currentTimeText = _getCurrentTimeText();
    if (_timeText != currentTimeText) {
      setState(() => _timeText = currentTimeText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text("~$_timeText", style: LastUpdateDate._style);
  }

  Duration get _duration => DateTime.now().difference(widget.lastUpdateDate);

  String _getCurrentTimeText() {
    final duration = _duration;
    if (duration.inDays > 0) return "${duration.inDays}d";
    if (duration.inHours > 0) return "${duration.inHours}h";
    if (duration.inMinutes > 0) return "${duration.inMinutes}m";
    return "${duration.inSeconds}s";
  }
}
