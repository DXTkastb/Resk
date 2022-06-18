import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../buttons/del_button.dart';
import '../buttons/done_button.dart';
import '../buttons/update_button.dart';
import '../tasks/task_list_fetch.dart';
import '../tasks/taskData.dart';

class TaskWidget extends StatefulWidget {
  final double width;

  const TaskWidget(this.width);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  List<Color> getColors(int value) {
    return const [
      Color.fromRGBO(255, 203, 35, 1.0),
      Color.fromRGBO(255, 215, 111, 1.0)
    ];
  }

  void removeAnyScaffoldSnack(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Card(
        elevation: 5,
        color: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
          child: Consumer<TaskData>(
            builder: (ctx, taskData, child) {
              int toggleReach = (taskData.reached == 0) ? 1 : 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardText(taskData.title, true),
                        const SizedBox(
                          height: 10,
                        ),
                        CardText(taskData.description, false),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DoneButton(() async {
                              taskData.didupdate(taskData.title,
                                  taskData.description, toggleReach);
                            }, (taskData.reached)),
                            const SizedBox(
                              width: 4,
                            ),
                            UpdateButtonIco(() {
                              removeAnyScaffoldSnack(context);
                              Navigator.of(context).pushNamed('/updatetask',
                                  arguments: taskData);
                              //     .then((value) async {
                              //   if (value is List) {
                              //     await taskData.didupdate(
                              //       value[0],
                              //       value[1],
                              //       value[2],
                              //     );
                              //     // Provider.of<TaskData>(context,listen: false).didupdate(value[0],value[1],value[2]);
                              //   }
                              // })
                              // ;
                            }),
                            const SizedBox(
                              width: 4,
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: getColors(taskData.score),
                      ),
                    ),

                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Text(
                              '${taskData.score}',
                              style: Theme.of(context).textTheme.headline2,
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
  final bool istitle;

  const CardText(this.text, this.istitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      text,
      style: (istitle)
          ? Theme.of(context).textTheme.headline1
          : Theme.of(context).textTheme.headline3,
    );
  }
}
