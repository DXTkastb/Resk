import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../buttons/add_button.dart';
import '../buttons/cancel_button.dart';
import '../tasks/task_list_fetch.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

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
      if (mounted) {
        Navigator.of(ctx).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!processing)
        ? Scaffold(
      backgroundColor: const Color.fromRGBO(197, 179, 255 , 1),
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
                      maxLength: 30,
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(),
                          focusColor: Color.fromRGBO(42, 27, 60, 1),
                          hoverColor: Color.fromRGBO(42, 27, 60, 1),
                          labelText: 'TITLE',
                          labelStyle: TextStyle(
                              fontSize: 14, color: Color.fromRGBO(42, 27, 60, 1),)),
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
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(),
                          focusColor: Color.fromRGBO(42, 27, 70, 1),
                          hoverColor:  Color.fromRGBO(42, 27, 70, 1),
                          labelText: 'DESCRIPTION',
                          labelStyle:  TextStyle(
                              fontSize: 14, color:Color.fromRGBO(42, 27, 70, 1),)),
                      style: const TextStyle(
                          fontSize: 22, decoration: TextDecoration.none),
                      focusNode: myFocusNode,
                      controller: tx2,
                      keyboardType: TextInputType.multiline,
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
    ): Container(
            color: Colors.deepPurple,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
  }
}
