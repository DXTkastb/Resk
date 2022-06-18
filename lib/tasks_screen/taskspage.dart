import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/tasks/taskData.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';
import 'package:reminder_app/tasks_screen/taskWid.dart';

import '../dbhelper/databaseManager.dart';

class TasksPage extends StatelessWidget {
  final Future tasklist;

  const TasksPage(this.tasklist);

  List<Widget> getCards(Object tlist,double width) {

    List<Widget> returnList=[];
    (tlist as List).forEach((element) {
      returnList.add(
        ChangeNotifierProvider<TaskData>.value(value: element,
        builder: (_,tt){
          return TaskWidget(width);
        },)
      );
    });
    return returnList;

  }

  @override
  Widget build(BuildContext context) {

    var width=MediaQuery.of(context).size.width;
    // TODO: implement build
    return FutureBuilder(
      future: tasklist,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<TaskListFetch>(builder: (ctx,tlist,_){


            if(tlist.listtaskdata.isEmpty) {
              return  Center(child: Text('Add Tasks!',style: Theme.of(context).textTheme.headline6,),);
            }

            return ListView(
              children: [
                const SizedBox(height: 7,),
                ...getCards(tlist.listtaskdata,width)
              ],
            );
          });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}


