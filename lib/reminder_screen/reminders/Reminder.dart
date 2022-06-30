import 'dart:async';

import 'package:flutter/material.dart';

class Reminder extends StatefulWidget {
  final int t;

  const Reminder(this.t);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReminderState();
  }
}

class ReminderState extends State<Reminder> {
  Timer? time;
  bool reached = false;

  @override
  void initState() {
    if (!timecheck()) {
      run();
    } else {
      reached = !reached;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (time != null && time!.isActive) {
      time!.cancel();
    }
    super.dispose();
  }

  bool timecheck() {
    return DateTime.now().hour >= widget.t;
  }

  void run() {
    time = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (timecheck()) {
        setState(() {
          reached = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reached) {
      if (time != null && time!.isActive) {
        time!.cancel();
      }
    }
    // TODO: implement build
    return Container(
      color: reached ? Colors.green : Colors.blue,
      width: 200,
      height: 200,
    );
  }
}
