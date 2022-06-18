import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../buttons/add_button.dart';
import '../buttons/cancel_button.dart';
import '../tasks/task_list_fetch.dart';

class AddTask extends StatefulWidget {
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

  void onadd(BuildContext ctx) {
    setState(() {
      processing = true;
    });

    Future.delayed(Duration.zero).then((_) async {
      await Future.delayed(Duration.zero);
      await Provider.of<TaskListFetch>(ctx, listen: false)
          .addTask(tx1.text, tx2.text);
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
        ? Builder(
            builder: (BuildContext ctx) {
              return Scaffold(
                backgroundColor: Colors.deepPurple.shade100,
                body: Center(
                  child: Container(
                    // decoration:  BoxDecoration(border: Border.all(width: 0) ,
                    // color: Colors.white,
                    // borderRadius:const  BorderRadius.all(Radius.circular(10)),
                    //   boxShadow: const [BoxShadow(offset: Offset(0, 9),blurRadius: 18,spreadRadius: 0.2)],
                    // ),
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            maxLength: 30,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(),
                                focusColor: Colors.teal.shade900,
                                hoverColor: Colors.teal.shade900,
                                labelText: 'TITLE',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.teal.shade900)),
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
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(),
                                focusColor: Colors.teal.shade900,
                                hoverColor: Colors.teal.shade900,
                                labelText: 'DESCRIPTION',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.teal.shade900)),
                            style: const TextStyle(
                                fontSize: 22, decoration: TextDecoration.none),
                            focusNode: myFocusNode,
                            controller: tx2,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              }
                              return 'enter description!';
                            },
                            minLines: 2,
                            maxLines: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AddButton(() {
                                  if ((_formKey.currentState!.validate())) {
                                    onadd(context);
                                  }
                                }),
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
            color: Colors.deepPurple,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
  }
}
