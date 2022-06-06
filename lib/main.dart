import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/add_screen/add_task.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';
import 'package:reminder_app/reminder_screen/remiderpage.dart';
import 'package:reminder_app/tasks/task_list_fetch.dart';
import 'package:reminder_app/tasks_screen/taskspage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseManager databaseManager = DatabaseManager.databaseManagerInstance;
  await databaseManager.initiateDatabse();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (BuildContext context) {
        return TaskListFetch();
      },
      child: MaterialApp(
        routes:{
          '/addtask':(_){
            return AddTask();
          },
        } ,
        home: MainApp(),
      ),
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

  int _currentindex = 0;




  @override
  void didChangeDependencies() {
    tasklist=Provider.of<TaskListFetch>(context,listen: false).setTasks().then((value) {
      print('called via provider!');
    });
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: (_currentindex==0)?TasksPage(tasklist):ReminderPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

                if(_currentindex==0){
                  Navigator.of(context).pushNamed('/addtask');
                }
                else if(_currentindex==1){

                }

        },
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
