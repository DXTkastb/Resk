import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sync_tasks/taskSyncUpdate.dart';
import '../reminder_screen/reminders/Reminder.dart';

class ReminderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('appbar'),
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
        body: ListView(children: const [
          Text('Coming Soon'),
          Reminder(15),
        ])
    ,
    floatingActionButton:  FloatingActionButton(onPressed: () {


      Provider.of<SyncTaskUpdate>(context, listen: false).syncUpdate(true);Navigator.of(context).pop(); },
    child: const Text('ADD'),),
    );
  }
}
