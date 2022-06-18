import 'package:flutter/material.dart';

import '../buttons/cancel_button.dart';
import '../buttons/done_button.dart';
import '../buttons/update_button.dart';
import '../tasks/taskData.dart';

class UpdateScreen extends StatefulWidget {
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode fnode;
  bool updating = false;
  late int donebutton;
  late TaskData task;
  late TextEditingController tx1;
  late TextEditingController tx2;

  void updateTask() async {
    setState(() {
      updating = !updating;
    });
    if (mounted) {
      await task.didupdate(tx1.text, tx2.text, donebutton);

      Navigator.of(context).pop(
          // [tx1.text,tx2.text,int.parse(tx3.text)]
          );
    }
  }

  @override
  void didChangeDependencies() {
    fnode = FocusNode();
    task = (ModalRoute.of(context)!.settings.arguments) as TaskData;
    donebutton = task.reached;
    tx1 = TextEditingController(text: task.title);
    tx2 = TextEditingController(text: task.description);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    fnode.dispose();
    tx1.dispose();
    tx2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!updating)
        ?  Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 30, left: 50, right: 50),


              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'TITLE',
                          focusedBorder: const UnderlineInputBorder(),
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple.shade800),
                          focusColor: Colors.deepPurple.shade800,
                          hoverColor: Colors.deepPurple.shade800,
                        ),
                        controller: tx1,
                        maxLength: 30,
                        style: Theme.of(context).textTheme.headline6,
                        textInputAction: TextInputAction.next,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(),
                            focusColor: Colors.deepPurple.shade800,
                            hoverColor: Colors.deepPurple.shade800,
                            labelText: 'DESCRIPTION',
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.deepPurple.shade800)),
                        controller: tx2,
                        style: Theme.of(context).textTheme.headline6,
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 2,
                        maxLength: 100,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: DoneButton(() {
                          setState(() {
                            donebutton = (donebutton == 0) ? 1 : 0;
                          });
                        }, donebutton),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UpdateButton(() {
                            if (_formKey.currentState!.validate()) {
                              updateTask();
                            }
                          }),
                          const SizedBox(
                            width: 10,
                          ),
                          CancelButton(() {
                            Navigator.of(context).pop(false);
                          })
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    )
        : Container(
            color: Colors.deepPurple.shade700,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )));
  }
}
