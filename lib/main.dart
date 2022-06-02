import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reminder_app/reminder_screen/remiderpage.dart';
import 'package:reminder_app/tasks_screen/taskspage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  late Timer time;
  @override
  void initState() {
    run();
    super.initState();
  }

  @override
  void dispose(){
    time.cancel();
    super.dispose();
  }

  void run() {
    time=
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState((){

        _currentindex=0;

      });

    });

  }

  int _currentindex = 0;

  List<Widget> widgetlist = [
    ReminderPage(),
    TasksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: widgetlist[_currentindex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: (_currentindex == 0) ? Colors.teal : Colors.deepPurple,
        child: const Icon(Icons.add_box_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        onTap: (x) {
          if (_currentindex != x) {
            setState(() {
              _currentindex = x;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.task_rounded,
              ),
              label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.alarm_rounded,
              ),
              label: 'Reminders'),
        ],
      ),
      appBar: AppBar(
        title: const Text('Reminder App'),
      ),
    );
  }
}
