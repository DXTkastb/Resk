import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/sync_tasks/taskSyncUpdate.dart';
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
          Consumer<SyncTaskUpdate>(
            builder: (_,f,g){
              return Builder(builder:(_){

                return Text('dfdf');
              } );
            },
          ),
          Reminder(15),
          Reminder(13),
          Reminder(14),
        ])
    ,
    floatingActionButton:  FloatingActionButton(onPressed: () {


      Provider.of<SyncTaskUpdate>(context, listen: false).syncUpdate(true);Navigator.of(context).pop(); },
    child: const Text('Press'),),
    );
  }
}
