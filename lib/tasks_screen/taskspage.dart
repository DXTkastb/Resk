import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/tasks/taskData.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';
import 'package:reminder_app/tasks_screen/taskWid.dart';

import '../dbhelper/databaseManager.dart';

class TasksPage extends StatelessWidget {
  final Future tasklist;



  const TasksPage(this.tasklist);

  List<Widget> getCards(Object tlist) {

    List<Widget> returnList=[];
    (tlist as List).forEach((element) {
      returnList.add(TaskWidget(element) );
    });
    return returnList;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: tasklist,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<TaskListFetch>(builder: (ctx,tlist,_){
            return ListView(
              children: [
                ...getCards(tlist.listtaskdata)
              ],
            );
          });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}


