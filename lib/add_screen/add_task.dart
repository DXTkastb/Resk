import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/tasks/taskData.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';

class AddTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      color: Colors.teal.shade300,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: AddTaskForm(),
    );
  }
}

class AddTaskForm extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskForm();
  }
}

class TaskForm extends State<AddTaskForm> {

  bool processing=false;

  void onadd(BuildContext ctx){

    setState((){
      processing=true;
    });

    Future.delayed(Duration.zero).then((_) async {
      await Future.delayed(Duration.zero);
      await Provider.of<TaskListFetch>(ctx,listen: false).addTask( 'title','DES', 0, 0);
    }).then((value) async {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(ctx).pop();
    });

  }



  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!processing) ?Container(
      alignment: Alignment.center,
      height: 300,
      width: 300,
      child: Builder(
        builder: (BuildContext ctx){
          return
            Scaffold(
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {}
                        return 'enter title!';
                      },
                    ),
                    TextFormField(
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
                              // if (_formKey.currentState!.validate()) {
                              //   // If the form is valid, display a snackbar. In the real world,
                              //   // you'd often call a server or save the information in a database.

                              //   );
                              // }
                            },
                            child: const Text('ADD')),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('CANCEL'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
        },
      ),
    ):const Center(child: CircularProgressIndicator(),);
  }

}
