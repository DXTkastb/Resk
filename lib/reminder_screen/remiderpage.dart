import 'package:flutter/material.dart';
import '../reminder_screen/reminders/Reminder.dart';

class ReminderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('appbasr'),
        ),
        drawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tasks')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Stats'))
              ],
            ),
          ),
        ),
        body: ListView(children: [
          Reminder(15),
          Reminder(13),
          Reminder(14),
        ]));
  }
}
