import 'package:flutter/material.dart';
import 'package:reminder_app/notificationapi/notificationapi.dart';
import 'package:reminder_app/tasks/taskData.dart';

class ReminderButton extends StatelessWidget {
  final TaskData taskData;

  const ReminderButton(this.taskData, {Key? key})
      : super(key: key);



  @override
  Widget build(BuildContext context) {



    // TODO: implement build
    return GestureDetector(
      onTap: () async {

          TimeOfDay? timeOfDay = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
          if (timeOfDay!=null){
            DateTime dt=DateTime.now();

            if(taskData.rem==1){
                          await NotificationApi.deleteNotifications(taskData.index);
            }


            await NotificationApi.launchPeriodicNotification(taskData.index, taskData.title, taskData.description, DateTime(dt.year,dt.month,dt.day,timeOfDay.hour,timeOfDay.minute));

            if(taskData.rem==0) {
              taskData.didAddReminder(1);
            }

          }


      },
      onLongPress: () async {
        if(taskData.rem==1) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removing reminder')));
          await taskData.didAddReminder(0);
        }

      },
      child: Container(
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(11),
        child:  Icon(Icons.access_time_rounded,
            size: 13, color: (taskData.rem==1)?Colors.white:Colors.deepPurple.shade200),
      ),
    );
  }



}
