import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';

import '../tasks/taskData.dart';

class TaskWidget extends StatelessWidget {
  final TaskData taskData;

  const TaskWidget(this.taskData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardText(taskData.title, 1),
            CardText(taskData.description, 2),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/updatetask',
                          arguments: taskData);
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
