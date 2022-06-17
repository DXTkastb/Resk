import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/add_screen/add_task.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';
import 'package:reminder_app/reminder_screen/remiderpage.dart';
import 'package:reminder_app/tasks/btask_list_fetch.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';
import 'package:reminder_app/tasks_screen/brieftaskspage.dart';
import 'package:reminder_app/tasks_screen/taskspage.dart';
import 'package:reminder_app/update_screen/updateScreen.dart';

import 'add_screen/add_btask.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  DatabaseManager databaseManager = DatabaseManager.databaseManagerInstance;

  await databaseManager.initiateTask();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskListFetch>(
          create: (BuildContext context) {
            return TaskListFetch();
          },
        ),
        ChangeNotifierProvider<BtaskListFetch>(
          create: (BuildContext context) {
            return BtaskListFetch();
          },
        ),
      ],
     builder: (a,b){
        return MaterialApp(
          routes: {
            '/addtask': (_) {
              return AddTask();
            },
            '/addbtask': (_) {
              return AddBTask();
            },
            '/updatetask': (_) {
              return UpdateScreen();
            },
            '/reminderpage': (_) {
              return ReminderPage();
            }
          },
          home: MainApp(),
        );
     },
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
  late Future tasklist;
  late Future btasklist;

  int _currentindex = 0;

  @override
  void didChangeDependencies() {

    tasklist = Provider.of<TaskListFetch>(context, listen: false).setTasks();
    btasklist = Provider.of<BtaskListFetch>(context, listen: false).setTasks();
    super.didChangeDependencies();
  }

  void removeAnyScaffoldSnack(){
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/reminderpage');
                  },
                  child: const Text('Reminders',style: TextStyle(),)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Stats'))
            ],
          ),
        ),
      ),
      body:
          (_currentindex == 0) ? BriefTaskPage(btasklist):TasksPage(tasklist),
      // Container(
      //         color: Colors.blueGrey,
      //         width: double.infinity,
      //         height: double.infinity,
      //       ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentindex == 1) {
            removeAnyScaffoldSnack();
            Navigator.of(context).pushNamed('/addtask').then((value) {
              if (value == true) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Task Added!')));
              }
            });
          } else {
            removeAnyScaffoldSnack();
            Navigator.of(context).pushNamed('/addbtask').then((value) {
              if (value == true) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Task Added!')));
              }
            });

          }
        },
        backgroundColor: (_currentindex == 0) ? Colors.teal : Colors.deepPurple,
        child: const Icon(Icons.add_box_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentindex,
        onTap: (x) {
          removeAnyScaffoldSnack();
          if (_currentindex != x) {
            setState(() {
              _currentindex = x;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.teal,
              icon: Icon(
                Icons.task_rounded,
              ),
              label: 'Brief Tasks'),

          BottomNavigationBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.alarm_rounded,

              ),
              label: 'Daily Tasks'),
        ],
      ),
      appBar: AppBar(
        backgroundColor: (_currentindex==1)?Colors.deepPurple:Colors.teal,
        title: const Text('Reminder App'),
      ),
    );
  }
}
