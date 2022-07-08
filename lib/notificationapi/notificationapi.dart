import 'dart:typed_data';

import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationApi {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();
  static final onNoti = BehaviorSubject<String?>();

  static void showAll() async {
    for (var element
        in (await _notificationPlugin.pendingNotificationRequests())) {
      //check all notifications.
    }
  }

  static Future showNotification() async {
    _notificationPlugin.show(10, 'XXXX2', 'XCVC', await _notiDetails(), payload: 'Custom_Sound');
  }

  static Future<void> launchPeriodicNotification(
      int id, String title, String body, DateTime dateTime) async {
    tz.initializeTimeZones();
    _notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        TZDateTime.from(dateTime,
            getLocation('Asia/Kolkata')),
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
          color: const Color.fromARGB(255, 66, 165, 245),
          playSound: true,
          vibrationPattern: Int64List(5),
          enableVibration: true,
          importance: Importance.max,
        ));
  }
  
  static Future<void> deleteNotifications(int id) async{
    await _notificationPlugin.cancel(id);
  }

  static Future<void> launchUpdateNotification(
      int id,String title,String body, DateTime dateTime) async {
    tz.initializeTimeZones();
    _notificationPlugin.zonedSchedule(
        id,
        'Update Task Progress !',
        '',
        TZDateTime.from(dateTime,
            getLocation('Asia/Kolkata')),
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
    // final details= await _noti.getNotificationAppLaunchDetails();
    // if(details!=null && details.didNotificationLaunchApp){
    //   onNoti.add('123');
    // }
    const settings = InitializationSettings(android: android);
    await _notificationPlugin.initialize(
      settings,
    );
    //       onSelectNotification: (string) {
    //   onNoti.add(string);
    // });
    DateTime now=DateTime.now();

    launchUpdateNotification(1,'Update your Tasks!','', DateTime(now.year,now.month,now.day,12));
    launchUpdateNotification(2,'Update your Tasks!','',  DateTime(now.year,now.month,now.day,17));
    launchUpdateNotification(3,'Update your Tasks!','',  DateTime(now.year,now.month,now.day,21));
  }
}