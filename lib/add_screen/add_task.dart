import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../buttons/add_button.dart';
import '../buttons/cancel_button.dart';
import '../functions/functions.dart';
import '../statwids/statProvider.dart';
import '../tasks/task_list_fetch.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskForm();
  }
}

class TaskForm extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController tx1 = TextEditingController();

  TextEditingController tx2 = TextEditingController();
  int reminderText = 9999;
  late FocusNode myFocusNode;

  bool processing = false;

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    tx1.dispose();
    tx2.dispose();
    super.dispose();
  }

  Future<void> onadd(BuildContext ctx) async {
    setState(() {
      processing = true;
    });
    int s = Provider.of<StatProvider>(context, listen: false).score;
    int ts = Provider.of<StatProvider>(context, listen: false).totalScore + 1;

    await Provider.of<TaskListFetch>(ctx, listen: false)
        .addTask(tx1.text, tx2.text, reminderText)
        .then((_) async {
      await Provider.of<StatProvider>(context, listen: false)
          .updateScore(s, ts);
    });
    if (mounted) {
      Navigator.of(ctx).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!processing)
        ? Scaffold(
            backgroundColor: const Color.fromRGBO(197, 179, 255, 1),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            maxLength: 30,
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(),
                                focusColor: Color.fromRGBO(42, 27, 60, 1),
                                hoverColor: Color.fromRGBO(42, 27, 60, 1),
                                labelText: 'TITLE',
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(42, 27, 60, 1),
                                )),
                            style: const TextStyle(
                                fontSize: 22, decoration: TextDecoration.none),
                            textInputAction: TextInputAction.next,
                            controller: tx1,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(myFocusNode);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter title!';
                              }
                            },
                          ),
                          TextFormField(
                            maxLength: 100,
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(),
                                focusColor: Color.fromRGBO(42, 27, 70, 1),
                                hoverColor: Color.fromRGBO(42, 27, 70, 1),
                                labelText: 'DESCRIPTION',
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(42, 27, 70, 1),
                                )),
                            style: const TextStyle(
                                fontSize: 22, decoration: TextDecoration.none),
                            focusNode: myFocusNode,
                            controller: tx2,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay? timeofday = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          const TimeOfDay(hour: 0, minute: 0));
                                  if (timeofday != null) {
                                    int timeValue =
                                        timeofday.hour * 100 + timeofday.minute;
                                    if (reminderText != timeValue) {
                                      setState(() {
                                        reminderText = timeValue;
                                      });
                                    }
                                  }
                                },
                                onLongPress: () {
                                  setState(() {
                                    reminderText = 9999;
                                  });
                                },
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 35)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        size: 13, color: Colors.white),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      (reminderText == 9999)
                                          ? 'Add Reminder'
                                          : Functions.getTimeFromInteger(
                                              reminderText),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AddButton(() {
                                  if ((_formKey.currentState!.validate())) {
                                    onadd(context);
                                  }
                                }),
                                CancelButton(() {
                                  Navigator.of(context).pop(false);
                                })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            color: Colors.deepPurple,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 30,height: 30,
              child: CircularProgressIndicator(strokeWidth: 6,
                color: Colors.white,
              ),
            ));
  }
}
