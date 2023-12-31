import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BookingsLoadingAnimation extends StatelessWidget {
  const BookingsLoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: const Color(0xFF5ABAEB),
        secondRingColor: Colors.green,
        thirdRingColor: Colors.red,
        size: 75.0,
      ),
    );
  }
}
