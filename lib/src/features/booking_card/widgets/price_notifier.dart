import 'package:flutter/material.dart';

class PriceNotifier extends StatelessWidget {
  static const _baseStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.amber,
  );

  final num priceNotifier;
  const PriceNotifier({required this.priceNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "\$$priceNotifier",
      style: _baseStyle,
    );
  }
}
