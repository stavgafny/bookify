import 'package:flutter/material.dart';

class BookingsErrorMessage extends StatelessWidget {
  static const BookingsErrorMessage noBookings = BookingsErrorMessage._(
    title: "No bookings",
    description: "Failed to reach server and no prior local bookings found",
  );

  static const BookingsErrorMessage emptyBookings = BookingsErrorMessage._(
    title: "Empty bookings",
    description: "No bookings for now, check again later",
  );

  static BookingsErrorMessage internalError(Object? error) {
    return BookingsErrorMessage._(
      title: "Internal error retrieving bookings",
      description: (error ?? "NO ERROR MESSAGE").toString(),
    );
  }

  final String title;
  final String description;

  const BookingsErrorMessage._({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(description),
            ],
          ),
        )
      ],
    );
  }
}
