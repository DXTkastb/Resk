import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/tasks/taskData.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';

class AddTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskForm();
  }
}

class TaskForm extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController tx1 = TextEditingController(
    text: 'Title'
  );

  TextEditingController tx2 = TextEditingController(
    text: 'Description'
  );

  bool processing = false;


  @override
  void dispose() {

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
          .addTask('title', 'DES', 0, 0);
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
        ? Container(
            color: Colors.amber.shade100,
            alignment: Alignment.center,
            child: Builder(
              builder: (BuildContext ctx) {
                return SizedBox(
                  width: 300,
                  child: Scaffold(
                    body: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: tx1,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {}
                              return 'enter title!';
                            },
                          ),
                          TextFormField(
                            controller: tx2,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {}
                              return 'enter description!';
                            },
                            minLines: 2,
                            maxLines: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    onadd(context);
                                  },
                                  child: const Text('ADD')),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                                child: const Text('CANCEL'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
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
