import 'package:flutter/material.dart';
import 'package:reminder_app/tasks/taskData.dart';

import '../dbhelper/databaseManager.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: getCards(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ...snapshot.data
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Future<List<Widget>> getCards() async {
  var list1 = (await DatabaseManager.databaseManagerInstance.queryRows());
  List<Widget> list2=[];
  list1.forEach((element) {
    int index=0;
    String title='';
    String description='';
    int reach=0;
    int score=0;
    element.forEach((key, value) {
      switch (key) {
        case 'ID':
          {
            index = value;
          }
          break;
        case 'TITLE':
          {
            title = value;
          }
          break;
        case 'DESCRIPTION':
          {
            description = value;
          }
          break;
        case 'REACH':
          {
            reach = value;
          }
          break;
        case 'SCORE':
          {
            score = value;
          }
          break;
      }
    }




    );
    list2.add(
TaskWidget(TaskData(index,title,description,reach,score))

    );

  });
  return list2;
}


class TaskWidget extends StatelessWidget{
  final TaskData taskData;
  const TaskWidget(this.taskData);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(

        children: [
  CardText(taskData.title),
          CardText(taskData.description),
        ],
      ),


    );
  }

}

class CardText extends StatelessWidget{
  final String text;
  const CardText(this.text);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Text(text,style: const TextStyle(fontSize: 12),);
  }


}