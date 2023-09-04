import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

final _alertNotification = NotificationChannel(
  channelGroupKey: BookingsNotificationsService._channelGroupKey,
  channelKey: BookingsNotificationsService._channelAlertsKey,
  channelName: 'Bookings alerts notifications',
  channelDescription: 'Notification channel for Booking changes',
  defaultColor: const Color(0xFF96D2F1),
  ledColor: Colors.white,
  importance: NotificationImportance.High,
  channelShowBadge: true,
  enableVibration: false,
  soundSource: 'resource://raw/res_alert_notification',
);

final _reminderNotification = NotificationChannel(
  channelGroupKey: BookingsNotificationsService._channelGroupKey,
  channelKey: BookingsNotificationsService._channelRemindersKey,
  channelName: 'Bookings reminder notifications',
  channelDescription: 'Notification channel for Booking reminders',
  defaultColor: Colors.amber,
  ledColor: Colors.white,
  importance: NotificationImportance.High,
  channelShowBadge: true,
  enableVibration: false,
  soundSource: 'resource://raw/res_reminder_notification',
);

class BookingsNotificationsService {
  static const String _channelGroupKey = 'bookings_channel_group';
  static const String _channelAlertsKey = 'bookings alerts';
  static const String _channelRemindersKey = 'bookings reminders';
  static int _channelId = 15;

  static Future<void> _initializeChannel() async {
    AwesomeNotifications().initialize(
      'resource://drawable/res_notification_app_icon',
      [
        _alertNotification,
        _reminderNotification,
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: _channelGroupKey,
          channelGroupName: _channelAlertsKey,
        ),
        NotificationChannelGroup(
          channelGroupKey: _channelGroupKey,
          channelGroupName: _channelRemindersKey,
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
    bool reminder = false,
  }) async {
    try {
      final notification =
          reminder ? _createReminderNotification : _createAlertNotification;
      return await notification(title, body);
    } catch (e) {
      return false;
    }
  }

  static _createAlertNotification(String title, String body) async {
    try {
      return await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: _channelId++,
          channelKey: _channelAlertsKey,
          title: title,
          body: body,
          actionType: ActionType.Default,
          displayOnForeground: false,
          category: NotificationCategory.Service,
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  static _createReminderNotification(String title, String body) async {
    try {
      return await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: _channelId++,
          channelKey: _channelRemindersKey,
          title: title,
          body: body,
          actionType: ActionType.Default,
          displayOnForeground: true,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.Default,
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
