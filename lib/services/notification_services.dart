import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: 'high_importance_channel',
            channelKey: 'high_importance_channel',
            channelName: 'Basic notification',
            channelDescription: 'Channel description',
            defaultColor: Color.fromARGB(0, 36, 123, 238),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            onlyAlertOnce: true,
            playSound: true,
            criticalAlerts: true,
          )
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'high_importance_channel',
              channelGroupName: 'Group_1'),
        ],
        debug: false);
    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static void scheduleNotification(Task task) {
    if (task.remind != null && task.remind! > 0) {
      // Calculate the reminder time before the task's start time
      final int reminderMinutes = task.remind!;

      // Parse the date and time strings to DateTime objects

      DateTime taskStartTime =
          DateFormat('M/d/yyyy h:mm a').parse('${task.date} ${task.startTime}');
      // Calculate the notification schedule time
      DateTime notificationTime =
          taskStartTime.subtract(Duration(minutes: reminderMinutes));

      // Create the notification content
      String notificationBody =
          '${task.title}: Reminder for the appointment starting at ${task.startTime}';
      String notificationPayload =
          task.toJson().toString(); // You can pass the task data as the payload

      // Schedule the notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          wakeUpScreen: true,
          criticalAlert: true,
          id: task.id!,
          channelKey: 'high_importance_channel',
          title: 'Appointment Reminder',
          body: notificationBody,
          payload: {'task_data': notificationPayload},
        ),
        schedule: NotificationCalendar.fromDate(date: notificationTime),
      );
    }
  }
}
