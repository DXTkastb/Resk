import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/buttons/del_button.dart';
import 'package:reminder_app/buttons/done_button.dart';
import 'package:reminder_app/buttons/update_button.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';

import '../tasks/taskData.dart';

class TaskWidget extends StatelessWidget {
  final double width;

  const TaskWidget(this.width);

  void removeAnyScaffoldSnack(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 5, left: 10, right: 10),
      child: Card(
        elevation: 5,
        color: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<TaskData>(
            builder: (ctx, taskData, child) {

              int toggleReach = (taskData.reached == 0) ? 1 : 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    // color: Colors.red,
                    width: width * 0.61,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardText(taskData.title, 1),
                        const SizedBox(
                          height: 10,
                        ),
                        CardText(taskData.description, 2),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DoneButton(() async {
                              taskData.didupdate(taskData.title,
                                  taskData.description, toggleReach);
                            },
                                (taskData.reached )),
                            const SizedBox(
                              width: 2,
                            ),
                            UpdateButton(() {
                              removeAnyScaffoldSnack(context);
                              Navigator.of(context)
                                  .pushNamed('/updatetask', arguments: taskData)
                                  .then((value) async {
                                if (value is List) {
                                  await taskData.didupdate(
                                    value[0],
                                    value[1],
                                    value[2],
                                  );
                                  // Provider.of<TaskData>(context,listen: false).didupdate(value[0],value[1],value[2]);
                                }
                              });
                            }),
                            const SizedBox(
                              width: 2,
                            ),
                            DeleteButton(() {
                              removeAnyScaffoldSnack(context);
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: const Text('delete task?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Provider.of<TaskListFetch>(
                                                        context,
                                                        listen: false)
                                                    .removeTask(taskData)
                                                    .then((_) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Text('delete')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('cancel')),
                                        ],
                                      ));

                              // async {
                            }, Colors.deepPurple),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    // width: width*0.2,
                    decoration: BoxDecoration(     color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${taskData.score}',
                              style: const TextStyle(fontSize: 22),
                            ))),
                  )
                ],
              );
            },
          ),
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
