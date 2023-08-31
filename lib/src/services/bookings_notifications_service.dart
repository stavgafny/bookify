import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class BookingsNotificationsService {
  static const String _channelGroupKey = 'bookings_channel_group';
  static const String _channelKey = 'Bookings group';
  static int _channelId = 15;

  static Future<void> _initializeChannel() async {
    AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      [
        NotificationChannel(
          channelGroupKey: _channelGroupKey,
          channelKey: _channelKey,
          channelName: 'Bookings notifications',
          channelDescription: 'Notification channel for Booking changes',
          defaultColor: Colors.amber,
          ledColor: Colors.white,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: _channelGroupKey,
          channelGroupName: _channelKey,
        )
      ],
      debug: true,
    );
  }

  static Future<void> _requestPermissionsIfNotAllowed() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  @pragma("vm:entry-point")
  static Future<bool> createNotification({
    required String title,
    required String body,
  }) async {
    try {
      return await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: _channelId++,
          channelKey: _channelKey,
          title: title,
          body: body,
          actionType: ActionType.Default,
          displayOnForeground: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  static Future<void> init() async {
    await _initializeChannel();
    await _requestPermissionsIfNotAllowed();
  }
}
