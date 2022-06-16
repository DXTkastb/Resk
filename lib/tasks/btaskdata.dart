import 'package:flutter/cupertino.dart';

class BTaskData extends ChangeNotifier{
  final int id;
  final String title;
  bool done;

  BTaskData(this.id, this.title, this.done);

  void onUpdate(){
    done=!done;
    notifyListeners();
  }
}

class BData extends ChangeNotifier{
  String date;
  final String title;
  bool done;

  BData(this.title, this.done,this.date);


}