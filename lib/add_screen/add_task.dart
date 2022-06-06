import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      height: 300,
      width: 300,
      child:
        Material(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType:  TextInputType.text,
                  validator: (value){
                        if(value!=null && value.isNotEmpty){

                        }
                      return 'enter title!';
                  },

                ),
                TextFormField(
                  keyboardType:  TextInputType.text,
                  validator: (value){
                    if(value!=null && value.isNotEmpty){

                    }
                    return 'enter description!';
                  },
                minLines: 2,
                  maxLines: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {


                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    }, child:const Text('ADD')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
  }
}
