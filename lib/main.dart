import 'dart:async';
import 'dart:ui';

import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_screen/add_btask.dart';
import 'add_screen/add_task.dart';
import 'dbhelper/databaseManager.dart';
import 'export_import/export_importpage.dart';
import 'homeview/appfront.dart';
import 'notificationapi/notificationapi.dart';
import 'statwids/statProvider.dart';
import 'tasks/btask_list_fetch.dart';
import 'tasks/task_list_fetch.dart';
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

class CentralApp extends StatefulWidget {
  const CentralApp({Key? key}) : super(key: key);

  @override
  State<CentralApp> createState() => _CentralAppState();
}

class _CentralAppState extends State<CentralApp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late OverlayEntry overlayEntry;
  late OverlayState overlayState;

  void showOverlay(SharedPreferences sharedPreferences) {
    overlayEntry = getOverLay(sharedPreferences);
    Overlay.of(context)!.insert(overlayEntry);
    overlayState = Overlay.of(context)!;
    _controller.forward();
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? app = prefs.get('initApp') as String?;
      bool? autos = await isAutoStartAvailable;
      if (app == null && autos == true) {
        if (mounted) {
          showOverlay(prefs);
        }
      } else {
        _controller.dispose();
      }
    });
    super.initState();
  }

  Future<void> onDone() async {
    await _controller.reverse();
    if (mounted && overlayState.mounted) {
      overlayEntry.remove();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement createState
    return
        //   const Center(
        //   child: Text(''),
        // );
        LayoutBuilder(builder: (ctx, cons) {
      return (MainApp(cons));
      // return Consumer<SyncTaskUpdate>(builder: (ctx, stu, _) {
      //   return (MainApp(cons));
      // });
    });
  }

  OverlayEntry getOverLay(SharedPreferences sharedPreferences) =>
      OverlayEntry(builder: (ctx) {
        return FadeTransition(
          opacity: _animation,
          child: Container(
            color: Colors.white.withOpacity(0.2),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(
                      bottom: 20, left: 25, right: 25, top: 27),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromRGBO(33, 33, 33, 1.0),
                  ),
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '! Autostart enables reminders even after device reboot. Allow autostart :',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await onDone();
                              await sharedPreferences.setString(
                                  'initApp', 'DONE');

                              await getAutoStartPermission().timeout(
                                  const Duration(seconds: 15),
                                  onTimeout: () {});
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(5)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                            child: const Text(
                              'ALLOW',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // await sharedPreferences.setString(
                              //     'initApp', 'UNDONE');
                              await onDone();
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5, right: 5)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                            child: const Text(
                              'NO',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
