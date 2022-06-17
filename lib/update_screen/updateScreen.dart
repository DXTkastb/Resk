import 'package:flutter/material.dart';
import 'package:reminder_app/buttons/cancel_button.dart';
import 'package:reminder_app/buttons/done_button.dart';
import 'package:reminder_app/buttons/update_button.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';
import 'package:reminder_app/tasks/taskData.dart';

class UpdateScreen extends StatefulWidget {

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode fnode;
  bool updating=false;
  late int donebutton;
  late TaskData task;
  late TextEditingController tx1;
  late TextEditingController tx2;


  void updateTask()  async {

    setState((){
      updating=!updating;
    });
    if (mounted) {
      await task.didupdate(tx1.text,tx2.text,donebutton);

      Navigator.of(context).pop(
          // [tx1.text,tx2.text,int.parse(tx3.text)]
          );
    }
  }


  @override
  void didChangeDependencies() {
    fnode=FocusNode();
    task = (ModalRoute.of(context)!.settings.arguments) as TaskData;
    donebutton=task.reached;
        tx1=TextEditingController(text: task.title);
    tx2=TextEditingController(text: task.description);

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


    return (!updating)?   Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
            body: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
                width: 300,

                child: Form(
                  key: _formKey,
                  child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                    TextFormField(controller: tx1,maxLength: 30,
                      style:const TextStyle(fontSize: 14),
                      textInputAction: TextInputAction.next,

                      autofocus: true,
                      validator:(value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    } ,), const SizedBox(height: 10,),
                    TextFormField(controller: tx2,  style:const TextStyle(fontSize: 14),
                      keyboardType: TextInputType.multiline,
minLines: 2,maxLines: 2,maxLength:100,
                      validator: (value){

                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },), const SizedBox(height: 10,),

                    DoneButton(() {

setState((){
  donebutton=(donebutton==0)?1:0;
});

                    }, donebutton),

                        const SizedBox(height: 17,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UpdateButton(() {
                          if (_formKey.currentState!.validate()) {
                            updateTask();
                          }
                          },' update'),
                      const SizedBox(width: 10,),
                      CancelButton(() {   Navigator.of(context).pop(false);})
                      ],
                    )

                  ]),
                ),
              ),
            ),

          )
      :
    Container(
        color: Colors.deepPurple.shade700,
        child: const Center(child: CircularProgressIndicator(
          color: Colors.white,
        )))
    ;
  }
}
