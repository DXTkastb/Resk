import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationApi {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();
  static final onNoti = BehaviorSubject<String?>();

  // static Future<void> showAll() async {
  //   for (var element
  //       in (await _notificationPlugin.pendingNotificationRequests())) {
  //   }
  // }

  static Future<void> launchPeriodicNotification(
      int id, String title, String body, DateTime dateTime) async {
    tz.initializeTimeZones();
    _notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        TZDateTime.from(dateTime, getLocation('Asia/Kolkata')),
        await _notiDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future _notiDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
      'taskChannel',
      'task',
      priority: Priority.high,
      colorized: true,
      subText: 'keep going!',
      color: const Color.fromARGB(255, 255, 255, 255),
      playSound: true,
      vibrationPattern: Int64List(5),
      enableVibration: true,
      importance: Importance.max,
    ));
  }

  static Future<void> deleteNotifications(int id) async {
    await _notificationPlugin.cancel(id);
  }

  static Future<void> launchUpdateNotification(
      int id, String title, String body, DateTime dateTime) async {
    tz.initializeTimeZones();
    _notificationPlugin.zonedSchedule(
        id,
        'Update Task Progress !',
        '',
        TZDateTime.from(dateTime, getLocation('Asia/Kolkata')),
        await _notiDetailsForUpdate(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future _notiDetailsForUpdate() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
      'updateChannel',
      'updates',
      priority: Priority.high,
      playSound: true,
      vibrationPattern: Int64List(5),
      enableVibration: true,
      importance: Importance.max,
    ));
  }

  static Future<void> init() async {
    const android = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const settings = InitializationSettings(android: android);
    await _notificationPlugin.initialize(
      settings,
    );

    DateTime now = DateTime.now();

    launchUpdateNotification(1, 'Update your Tasks!', '',
        DateTime(now.year, now.month, now.day, 15));
    launchUpdateNotification(2, 'Update your Tasks!', '',
        DateTime(now.year, now.month, now.day, 19));
    launchUpdateNotification(
        3,
        'Update your Tasks!',
        '',
        DateTime(
          now.year,
          now.month,
          now.day,
          23,
          45,
        ));
  }
}
