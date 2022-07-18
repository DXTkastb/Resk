import 'dart:async';

import 'package:android_autostart/android_autostart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_screen/add_btask.dart';
import 'add_screen/add_task.dart';
import 'dbhelper/databaseManager.dart';
import 'drawer/custom_drawer.dart';
import 'export_import/export_importpage.dart';
import 'notificationapi/notificationapi.dart';
import 'statwids/circleindicator.dart';
import 'statwids/statProvider.dart';
import 'tasks/btask_list_fetch.dart';
import 'tasks/task_list_fetch.dart';
import 'tasks_screen/brieftaskspage.dart';
import 'tasks_screen/taskspage.dart';
import 'update_screen/updateScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  DatabaseManager databaseManager = DatabaseManager.databaseManagerInstance;
  await databaseManager.initiateTask();
  await NotificationApi.init();
  runApp(const Sync());
}

class Sync extends StatefulWidget {
  const Sync({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SyncState();
  }
}

class SyncState extends State<Sync> {
  bool loading = false;
  DateTime today = DateTime.now();
  late Timer tt;

  @override
  void initState() {
    var tomorrow = today.add(const Duration(days: 1));
    Duration diff = DateTime(tomorrow.year, tomorrow.month, (tomorrow.day + 1))
        .difference(today);
    tt = Timer(diff, () async {
      setState(() {
        loading = true;
      });
      await DatabaseManager.databaseManagerInstance
          .onNewDay(DatabaseManager.databaseManagerInstance.db);
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        today = DateTime.now();
        loading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    tt.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.deepOrange,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      strokeWidth: 6,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'SYNCING DATA',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<SyncTaskUpdate>(
        //   create: (BuildContext context) {
        //     return SyncTaskUpdate();
        //   },
        // ),
        ChangeNotifierProvider<StatProvider>(
          create: (BuildContext context) {
            return StatProvider();
          },
        ),
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
            debugShowCheckedModeBanner: false,
            routes: {
              '/addtask': (_) {
                return const AddTask();
              },
              '/addbtask': (_) {
                return const AddBTask();
              },
              '/updatetask': (_) {
                return const UpdateScreen();
              },
              '/exportimport': (_) {
                return ImportExportWidget();
              },
              // '/reminderpage': (_) {
              //   return ReminderPage();
              // }
            },
            home: const CentralApp());
      },
    );
  }
}

class CentralApp extends StatelessWidget {
  const CentralApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement createState
    return LayoutBuilder(builder: (ctx, cons) {
      return (MainApp(cons));
      // return Consumer<SyncTaskUpdate>(builder: (ctx, stu, _) {
      //   return (MainApp(cons));
      // });
    });
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
    askAutoStart();
    super.initState();
  }

  Future<void> askAutoStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? app = prefs.get('initApp') as String?;
    if (app == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Autostart enables reminders even after device reboot. Allow autostart :'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      await AndroidAutostart.navigateAutoStartSetting;
                      prefs.setString('initApp', 'DONE');
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(5)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                    ),
                    child: const Text(
                      'ALLOW',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      await prefs.setString('initApp', 'UNDONE');
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.only(
                          top: 5, bottom: 5, left: 5, right: 5)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                    ),
                    child: const Text(
                      'NO',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  )
                ],
              )
            ],
          ),
          duration: const Duration(days: 1),
        ));
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void removeAnyScaffoldSnack() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  void setFutures() {
    tasklist = Provider.of<TaskListFetch>(context, listen: false).setTasks();
    btasklist = Provider.of<BtaskListFetch>(context, listen: false).setTasks();
    stat = Provider.of<StatProvider>(context, listen: false).setScore();
  }

  @override
  Widget build(BuildContext context) {
    // upFutures();

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
        backgroundColor: (_currentindex == 1) ? Colors.teal : Colors.deepPurple,
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
