import 'package:flutter/material.dart';

class LastPrice extends StatelessWidget {
  static const _baseTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );

  static const _saleColor = Colors.green;
  static const _nonSaleColor = Colors.red;

  final num? lastPrice;
  final num priceNotifier;
  const LastPrice({
    required this.lastPrice,
    required this.priceNotifier,
    super.key,
  });

  bool get _lessThen => (lastPrice ?? double.infinity) < priceNotifier;

  @override
  Widget build(BuildContext context) {
    return Text(
      lastPrice != null ? "\$$lastPrice" : "∞",
      style: _baseTextStyle.copyWith(
        color: _lessThen ? _saleColor : _nonSaleColor,
        decoration:
            _lessThen ? TextDecoration.none : TextDecoration.lineThrough,
        decorationColor: _nonSaleColor,
      ),
    );
  }
}
