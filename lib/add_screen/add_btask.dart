import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/buttons/cancel_button.dart';
import 'package:reminder_app/tasks/btask_list_fetch.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';

import '../buttons/add_button.dart';

class AddBTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskForm();
  }
}

class TaskForm extends State<AddBTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController tx1 = TextEditingController(text: 'Task Description');
  late DateTime date1;
  late DateTime date2;

  late FocusNode myFocusNode;

  bool processing = false;

  @override
  void initState() {
    date1 = DateTime.now();
    date2 = date1;
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    tx1.dispose();
    super.dispose();
  }

  void onadd(BuildContext ctx) {
    setState(() {
      processing = true;
    });

    Future.delayed(Duration.zero).then((_) async {
      await Future.delayed(Duration.zero);
      await Provider.of<BtaskListFetch>(ctx, listen: false)
          .addTask(tx1.text, date1, date2);
    }).then((value) async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(ctx).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;

    // TODO: implement build
    return (!processing)
        ? Builder(
            builder: (BuildContext ctx) {
              return Scaffold(
                body: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    height: size / 3,
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: tx1,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(myFocusNode);
                            },
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {}
                              return 'enter title!';
                            },
                          ),
                          Row(
                            children: [
                              ActionChip(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 5)))
                                      .then((value) {
                                    date1 = value!;
                                  });
                                },
                                label: const Text('date'),
                              ),
                              ActionChip(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 5)))
                                      .then((value) {
                                    date2 = value!;
                                  });
                                },
                                label: const Text('date'),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AddButton(
                                  () {
                                    onadd(context);
                                  },
                                ),
                                CancelButton(() {
                                  Navigator.of(ctx).pop(false);
                                })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Container(
            color: Colors.teal.shade700,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
  }
}
