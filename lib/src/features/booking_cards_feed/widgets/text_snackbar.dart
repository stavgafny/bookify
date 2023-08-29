import 'package:flutter/material.dart';

class TextSnackBar {
  static void _display(BuildContext context, String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF262531),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
        ),
      );
    });
  }

  static void faildToFetch(BuildContext context) {
    _display(context, "Network failure. Using last known data");
  }
}
