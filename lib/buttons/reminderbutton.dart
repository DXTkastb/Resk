import 'package:flutter/material.dart';

import '/functions/functions.dart';
import '/notificationapi/notificationapi.dart';
import '/tasks/taskData.dart';

class ReminderButton extends StatefulWidget {
  final TaskData taskData;

  const ReminderButton(this.taskData, {Key? key}) : super(key: key);

  @override
  State<ReminderButton> createState() => _ReminderButtonState();
}

class _ReminderButtonState extends State<ReminderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController ac;
  late Animation<double> animation;
  late String insideText;

  @override
  void initState() {
    insideText = Functions.getTimeFromInteger(widget.taskData.rem);
    ac = AnimationController(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(microseconds: 0),
      vsync: this,
    );
    animation = Tween(begin: 11.0, end: 0.0)
        .animate(CurvedAnimation(parent: ac, curve: Curves.linear));
    animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Functions.removeAnyScaffoldSnack(context);
        TimeOfDay? timeOfDay = await showTimePicker(
            context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));

        if (timeOfDay != null) {
          int timeValue = timeOfDay.hour * 100 + timeOfDay.minute;
          if (widget.taskData.rem != timeValue) {
            DateTime dt = DateTime.now();
            if (widget.taskData.rem != 9999) {
              await NotificationApi.deleteNotifications(widget.taskData.index);
            }
            await NotificationApi.launchPeriodicNotification(
                widget.taskData.index,
                widget.taskData.title,
                widget.taskData.description,
                DateTime(dt.year, dt.month, dt.day, timeOfDay.hour,
                    timeOfDay.minute));
            await widget.taskData.didAddReminder(timeValue);
            if (mounted) {
              setState(() {
                insideText = Functions.getTimeFromInteger(widget.taskData.rem);
              });
              ac.reverse();
            }
          }
        }
      },
      onLongPress: () async {
        Functions.removeAnyScaffoldSnack(context);
        if (widget.taskData.rem != 9999) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Removing reminder')));
          await NotificationApi.deleteNotifications(widget.taskData.index);
          await widget.taskData.didAddReminder(9999);
          if (mounted) await ac.forward();

          if (mounted) {
            setState(() {
              insideText = Functions.getTimeFromInteger(widget.taskData.rem);
            });
          }
        }
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: Colors.white),
              Text(
                insideText,
                style: TextStyle(
                    fontSize: animation.value,
                    color: Colors.white.withOpacity(animation.value / 11)),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ReminderButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // insideText=  Functions.getTimeFromInteger(widget.taskData.rem);
  }
}
