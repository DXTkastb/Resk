import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../buttons/cancel_button.dart';
import '../tasks/btask_list_fetch.dart';
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
    // TODO: implement build
    return (!processing)
        ? Scaffold( backgroundColor: Colors.teal.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(

              padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
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
                          return 'enter title!';
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
                          labelStyle: const TextStyle(color: Colors.white),
                          backgroundColor: Colors.teal.shade900,
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 30)))
                                .then((value) {

                                    date1 = value??date1;

                            });
                          },
                          label: const Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text('date')),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text('to'),
                        ),
                        ActionChip(
                          labelStyle: const TextStyle(color: Colors.white),
                          backgroundColor: Colors.teal.shade900,
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 30)))
                                .then((value) {

                              date2 = value??date2;
                            });
                          },
                          label: const Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text('date')),
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
                              } else if (DateTime.parse(
                                  DateFormat('yMMdd').format(date2))
                                  .difference(DateTime.parse(
                                  DateFormat('yMMdd')
                                      .format(date1)))
                                  .inDays <
                                  0) {
                                date1 = DateTime.now();
                                date2 = date1;
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: const Text(
                                            'End date is before Start date !'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text(
                                                  'ok, configure again'))
                                        ],
                                      );
                                    });
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
            color: Colors.teal.shade700,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
  }
}
