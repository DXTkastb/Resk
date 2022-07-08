import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/buttons/del_button.dart';
import '/buttons/done_button.dart';
import '/buttons/reminderbutton.dart';
import '/buttons/update_button.dart';
import '/drawer/alert_d.dart';
import '/notificationapi/notificationapi.dart';
import '/statwids/statProvider.dart';
import '/tasks/taskData.dart';
import '/tasks/task_list_fetch.dart';
import '../functions/functions.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Card(
        elevation: 5,
        color: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 21, left: 21, right: 21, bottom: 15),
          child: Consumer<TaskData>(
            builder: (ctx, taskData, child) {
              int toggleReach = (taskData.reached == 0) ? 1 : 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CardText(taskData.title, true),
                            const SizedBox(
                              height: 10,
                            ),
                            (taskData.description.isNotEmpty)
                                ? CardText(taskData.description, false)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      Container(
                        // width: width*0.2,
                        // margin: const EdgeInsets.only(top: 5),
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DoneButton(() async {
                        await taskData
                            .didupdate(
                          taskData.title,
                          taskData.description,
                          toggleReach,
                        )
                            .then((_) async {
                          int s =
                              Provider.of<StatProvider>(context, listen: false)
                                  .score;
                          int ts =
                              Provider.of<StatProvider>(context, listen: false)
                                  .totalScore;
                          if (taskData.reached == 1) {
                            await Provider.of<StatProvider>(context,
                                    listen: false)
                                .updateScore(s + 1, ts);
                          } else {
                            await Provider.of<StatProvider>(context,
                                    listen: false)
                                .updateScore(s - 1, ts);
                          }
                        });
                      }, (taskData.reached)),
                      const SizedBox(
                        width: 4,
                      ),
                      UpdateButtonIco(() {
                        Functions.removeAnyScaffoldSnack(context);
                        Navigator.of(context)
                            .pushNamed('/updatetask', arguments: taskData);
                      }),
                      const SizedBox(
                        width: 4,
                      ),
                      DeleteButton(() {
                        Functions.removeAnyScaffoldSnack(context);
                        showDialog(
                          context: context,
                          builder: (_) => CustomAlertD(
                              Colors.deepPurple.shade100, () async {
                            Navigator.of(context).pop();
                            int s = Provider.of<StatProvider>(context,
                                    listen: false)
                                .score;
                            int ts = Provider.of<StatProvider>(context,
                                    listen: false)
                                .totalScore;

                            if (taskData.reached == 1) {
                              await Provider.of<StatProvider>(context,
                                      listen: false)
                                  .updateScore(s - 1, ts - 1);
                            } else {
                              await Provider.of<StatProvider>(context,
                                      listen: false)
                                  .updateScore(s, ts - 1);
                            }
                            if (taskData.rem != 9999) {
                              await NotificationApi.deleteNotifications(
                                  taskData.index);
                            }
                            if (mounted) {
                              await Provider.of<TaskListFetch>(context,
                                      listen: false)
                                  .removeTask(taskData);
                            }

                            // await Future.delayed(Duration.zero, () async {
                            //
                            // });

                            //     .then((_) {
                            //   Navigator.of(context).pop();
                            // })
                          }, false),
                        );
                        // async {
                      }, Colors.deepPurple, () {}),
                      const Expanded(
                        child: SizedBox(
                          width: 0,
                        ),
                      ),
                      ReminderButton(taskData),
                    ],
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
