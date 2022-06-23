import 'package:flutter/cupertino.dart';

class BTaskData extends ChangeNotifier {
  int crid;
  final int days;
  final int id;
  final String title;
  bool done;

  BTaskData(this.days,this.id, this.title, this.done,this.crid);

  void onUpdate() {
    done = !done;
    notifyListeners();
  }
}

class BData {
  int crid;
  int x;
  String date;
  final String title;
  bool done;

  BData(this.x,this.title, this.done, this.date,this.crid);
}
