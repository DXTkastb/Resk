import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../buttons/add_button.dart';
import '../buttons/cancel_button.dart';
import '../functions/functions.dart';
import '../tasks/btask_list_fetch.dart';

class AddBTask extends StatefulWidget {
  const AddBTask({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskForm();
  }
}

class TaskForm extends State<AddBTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController tx1 = TextEditingController();
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

  String getDateText(DateTime dateTime) {
    var nowDate = DateTime.now();
    if (dateTime.day == nowDate.day && dateTime.month == nowDate.month) {
      return 'today';
    }
    return DateFormat('MMMMd').format(dateTime);
  }

  void onadd(BuildContext ctx) async {
    setState(() {
      processing = true;
    });
    await Provider.of<BtaskListFetch>(ctx, listen: false)
        .addTask(tx1.text, date1, date2);
    if (mounted) {
      Navigator.of(ctx).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!processing)
        ? Scaffold(
            backgroundColor: Colors.teal.shade100,
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
                            maxLength: 50,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(),
                                focusColor: Colors.teal.shade900,
                                hoverColor: Colors.teal.shade900,
                                labelText: 'DESCRIPTION',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.teal.shade900)),
                            style: const TextStyle(
                                fontSize: 22, decoration: TextDecoration.none),
                            textInputAction: TextInputAction.done,
                            controller: tx1,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(myFocusNode);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter description!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ActionChip(
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                backgroundColor: Colors.teal.shade900,
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 30)))
                                      .then((value) {
                                    setState(() {
                                      date1 = value ?? date1;
                                      if (Functions.compareDates(
                                          date1, date2)) {
                                        date2 = date1;
                                      }
                                    });
                                  });
                                },
                                label: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Text(getDateText(date1))),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('to'),
                              ),
                              ActionChip(
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                backgroundColor: Colors.teal.shade900,
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: date1,
                                          firstDate: date1,
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 30)))
                                      .then((value) {
                                    setState(() {
                                      date2 = value ?? date2;
                                    });
                                  });
                                },
                                label: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Text(getDateText(date2))),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AddButton(
                                  () {
                                    if (!(_formKey.currentState!.validate())) {
                                    } else {
                                      onadd(context);
                                    }
                                  },
                                ),
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
            color: Colors.teal.shade700,alignment: Alignment.center,
            child:  const SizedBox(
              width: 30,height: 30,
              child: CircularProgressIndicator(strokeWidth: 6,
                color: Colors.white,
              ),
            ));
  }
}
