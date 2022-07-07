import 'package:flutter/material.dart';

import '/functions/functions.dart';
import '/notificationapi/notificationapi.dart';
import '/tasks/taskData.dart';

class ReminderButton extends StatelessWidget {
  final TaskData taskData;

  const ReminderButton(this.taskData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Functions.removeAnyScaffoldSnack(context);
        TimeOfDay? timeOfDay = await showTimePicker(
            context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));

        if (timeOfDay != null) {
          int timeValue = timeOfDay.hour * 100 + timeOfDay.minute;
          if (taskData.rem != timeValue) {
            DateTime dt = DateTime.now();
            if (taskData.rem != 9999) {
              await NotificationApi.deleteNotifications(taskData.index);
            }
            await NotificationApi.launchPeriodicNotification(
                taskData.index,
                taskData.title,
                taskData.description,
                DateTime(dt.year, dt.month, dt.day, timeOfDay.hour,
                    timeOfDay.minute));
            taskData.didAddReminder(timeValue);
          }
        }
      },
      onLongPress: () async {
        Functions.removeAnyScaffoldSnack(context);
        if (taskData.rem != 9999) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Removing reminder')));
          await taskData.didAddReminder(9999);
        }
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          padding: const EdgeInsets.all(11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 13,
                  color                      : Colors.white),
              Text(
                Functions.getTimeFromInteger(taskData.rem),
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          )),
    );
  }
}
