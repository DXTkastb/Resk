import 'package:flutter/material.dart';

import '../tasks/taskData.dart';

class TaskWidget extends StatelessWidget {
  final TaskData taskData;

  const TaskWidget(this.taskData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Padding(
        padding:const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardText(taskData.title,1),
            CardText(taskData.description,2),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushReplacementNamed('/updatetask',arguments: taskData);

            }, child:const  Text('df'))
          ],
        ),
      ),
    );
  }
}

class CardText extends StatelessWidget {
  final String text;
  final int h;
  const CardText(this.text,this.h);

  @override
  Widget build(BuildContext context) {
    double norm=14;
    if(h==1)
      norm=20;
    else if(h==2)
      norm=16;

    // TODO: implement build
    return Text(

      text,

      style:  TextStyle(fontSize:norm),
    );
  }
}
