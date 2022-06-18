import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../drawer/custom_drawer.dart';
import './add_screen/add_btask.dart';
import '../add_screen/add_task.dart';
import '../dbhelper/databaseManager.dart';
import '../reminder_screen/remiderpage.dart';
import '../tasks/btask_list_fetch.dart';
import '../tasks/task_list_fetch.dart';
import '../tasks_screen/brieftaskspage.dart';
import '../tasks_screen/taskspage.dart';
import '../update_screen/updateScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
      builder: (a, b) {
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
          home: LayoutBuilder(builder: (ctx, cons) {
            return MainApp(cons);
          }),
        );
      },
    );
  }
}

class MainApp extends StatefulWidget {
  final BoxConstraints box;

  const MainApp(this.box);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  late Future tasklist;
  late Future btasklist;
  late double height;

  int _currentindex = 0;

  @override
  void initState() {
    height = widget.box.maxHeight;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    tasklist = Provider.of<TaskListFetch>(context, listen: false).setTasks();
    btasklist = Provider.of<BtaskListFetch>(context, listen: false).setTasks();
    super.didChangeDependencies();
  }

  void removeAnyScaffoldSnack() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer:  SafeArea(
        child: Drawer(
          child:CustomDrawerColumn(height),
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
              child: (_currentindex == 0)
                  ? BriefTaskPage(
                      btasklist,
                    )
                  : TasksPage(
                      tasklist,
                    ));
        },
      ),
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
        child: const Icon(
          Icons.add_box_rounded,
        ),
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
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.teal,
              icon: Icon(
                Icons.task_rounded,
                size: height / 27,
              ),
              label: 'Brief Tasks'),
          BottomNavigationBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.alarm_rounded,
                size: height / 27,
              ),
              label: 'Daily Tasks'),
        ],
      ),
      appBar: AppBar(
        toolbarHeight: height / 13,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        backgroundColor: (_currentindex == 1) ? Colors.deepPurple : Colors.teal,
        title:  Text(
          'Resk',
          style: TextStyle(fontSize:height/28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
