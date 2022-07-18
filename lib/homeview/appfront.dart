import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../functions/functions.dart';
import '/drawer/custom_drawer.dart';
import '/statwids/circleindicator.dart';
import '/statwids/statProvider.dart';
import '/tasks/btask_list_fetch.dart';
import '/tasks/task_list_fetch.dart';
import '/tasks_screen/brieftaskspage.dart';
import '/tasks_screen/taskspage.dart';

class MainApp extends StatefulWidget {
  final BoxConstraints box;

  const MainApp(this.box, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late Future tasklist;
  late Future btasklist;
  late Future stat;
  late double height;
  int _currentindex = 0;

  @override
  void initState() {
    height = widget.box.maxHeight;
    height = (height < 500) ? 500 : height;
    setFutures();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void setFutures() {
    tasklist = Provider.of<TaskListFetch>(context, listen: false).setTasks();
    btasklist = Provider.of<BtaskListFetch>(context, listen: false).setTasks();
    stat = Provider.of<StatProvider>(context, listen: false).setScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: SafeArea(
        child: Drawer(
          child: CustomDrawerColumn(height),
        ),
      ),
      body: LayoutBuilder(
        builder: (ctx, cons) {
          return Theme(
              data: ThemeData(
                  textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: cons.maxHeight / 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(1)),
                headline2: TextStyle(
                    fontSize: cons.maxHeight / 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                headline3: TextStyle(
                    fontSize: cons.maxHeight / 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6)),
                headline4: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: cons.maxHeight / 28,
                  fontWeight: FontWeight.bold,
                ),
                headline6: TextStyle(
                    fontSize: cons.maxHeight / 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
              child: (_currentindex == 1)
                  ? BriefTaskPage(
                      btasklist,
                    )
                  : TasksPage(
                      tasklist,
                    ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentindex == 0) {
            Functions.removeAnyScaffoldSnack(context);
            Navigator.of(context).pushNamed('/addtask').then((value) {
              if (value == true) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Task Added!')));
              }
            });
          } else {
            Functions.removeAnyScaffoldSnack(context);
            Navigator.of(context).pushNamed('/addbtask').then((value) {
              if (value == true) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Task Added!')));
              }
            });
          }
        },
        backgroundColor: (_currentindex == 1) ? Colors.teal : Colors.deepPurple,
        child: const Icon(
          Icons.add_box_rounded,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentindex,
        onTap: (x) {
          Functions.removeAnyScaffoldSnack(context);
          if (_currentindex != x) {
            setState(() {
              _currentindex = x;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.alarm_rounded,
                size: height / 27,
              ),
              label: 'Daily Tasks'),
          BottomNavigationBarItem(
              backgroundColor: Colors.teal,
              icon: Icon(
                Icons.task_rounded,
                size: height / 27,
              ),
              label: 'Brief Tasks'),
        ],
      ),
      appBar: AppBar(
        toolbarHeight: height / 13,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        backgroundColor: (_currentindex == 0) ? Colors.deepPurple : Colors.teal,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Resk',
              style:
                  TextStyle(fontSize: height / 28, fontWeight: FontWeight.bold),
            ),
            const Expanded(child: SizedBox()),
            (_currentindex == 0) ? CircleIndicator(stat) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
