import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/tasks/taskData.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';
import 'package:reminder_app/tasks_screen/taskWid.dart';

import '../dbhelper/databaseManager.dart';

class TasksPage extends StatelessWidget {
  final Future tasklist;

  const TasksPage(this.tasklist);

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

List<Widget> getCards(Object tlist) {

  List<Widget> returnList=[];
  (tlist as List).forEach((element) { 
    returnList.add(TaskWidget(element));
  });
return returnList;
  // List<Widget> list2 = [];
  // for (var element in (tlist as List)) {
  //   int index = 0;
  //   String title = '';
  //   String description = '';
  //   int reach = 0;
  //   int score = 0;
  //   element.forEach((key, value) {
  //     switch (key) {
  //       case 'ID':
  //         {
  //           index = value;
  //         }
  //         break;
  //       case 'TITLE':
  //         {
  //           title = value;
  //         }
  //         break;
  //       case 'DESCRIPTION':
  //         {
  //           description = value;
  //         }
  //         break;
  //       case 'REACH':
  //         {
  //           reach = value;
  //         }
  //         break;
  //       case 'SCORE':
  //         {
  //           score = value;
  //         }
  //         break;
  //     }
  //   });
  //   list2.add(TaskWidget(TaskData(index, title, description, reach, score)));
  // }
  // return list2;
}
