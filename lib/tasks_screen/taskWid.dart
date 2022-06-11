import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';

import '../tasks/taskData.dart';

class TaskWidget extends StatelessWidget {
final double width;

  const TaskWidget(this.width);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:Consumer<TaskData>(
          builder:(ctx,taskData,child){
            return  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.amberAccent,
                  width: width*0.60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardText(taskData.title, 1),
                      CardText(taskData.description, 2),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/updatetask',
                                    arguments: taskData).then((value) {
                                  if(value is List) {
                                    taskData.didupdate(value[0],value[1],value[2]);
                                    // Provider.of<TaskData>(context,listen: false).didupdate(value[0],value[1],value[2]);
                                  }
                                });
                              },
                              child: const Text('df')),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>  AlertDialog(
                                      title: const Text('delete ?'),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Provider.of<TaskListFetch>(context,
                                              listen: false)
                                              .removeTask(taskData).then((_){
                                            Navigator.of(context).pop();
                                          });


                                        }, child: const Text('delete')),
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();

                                        }, child: const Text('cancel')),
                                      ],
                                    ))
                                ;

                                // async {
                              },
                              child: const Text('delete'))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  // width: width*0.2,
                  color: Colors.amberAccent,
                  child: Center(child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('${taskData.score}',style: const TextStyle(fontSize: 22),))),
                )
              ],
            );
          } ,
        )
        ,
      ),
    );
  }
}

class CardText extends StatelessWidget {
  final String text;
  final int h;

  const CardText(this.text, this.h);

  @override
  Widget build(BuildContext context) {
    double norm = 14;
    if (h == 1)
      norm = 20;
    else if (h == 2) norm = 16;

    // TODO: implement build
    return Text(
      text,
      style: TextStyle(fontSize: norm),
    );
  }
}
