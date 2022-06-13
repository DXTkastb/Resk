import 'package:flutter/material.dart';
import 'package:reminder_app/buttons/update_button.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';
import 'package:reminder_app/tasks/taskData.dart';

class UpdateScreen extends StatefulWidget {

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  bool updating=false;

  late TaskData task;
  late TextEditingController tx1;
  late TextEditingController tx2;
  late TextEditingController tx3;

  void updateTask()  {
    setState((){
      updating=!updating;
    });
    if (mounted) {
      Navigator.of(context).pop([tx1.text,tx2.text,int.parse(tx3.text)]);
    }
  }


  @override
  void didChangeDependencies() {
    task = (ModalRoute.of(context)!.settings.arguments) as TaskData;

    tx1=TextEditingController(text: task.title);
    tx2=TextEditingController(text: task.description);
    tx3=TextEditingController(text: '${task.reached}');
    super.didChangeDependencies();
  }


  @override
  void dispose() {

    tx1.dispose();
    tx2.dispose();
    tx3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return (!updating)?   Scaffold(
            body: Center(
              child: Container(
                width: 300,
                height: 500,
                color: Colors.teal,

                child: Form(
                  child: Column(children: [

                    TextFormField(controller: tx1,),
                    TextFormField(controller: tx2,),
                    TextFormField(controller: tx3,

                    ),

                    Row(
                      children: [
                        UpdateButton(() {updateTask();},' update'),
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).pop(false);
                        }, child: const Text('CANCEL')),
                      ],
                    )

                  ]),
                ),
              ),
            ),
          )

      :
    Container(
        color: Colors.teal.shade900,
        child: const Center(child: CircularProgressIndicator(
          color: Colors.white,
        )))
    ;
  }
}
