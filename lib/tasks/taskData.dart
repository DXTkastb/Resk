import 'package:flutter/material.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';

class TaskData extends ChangeNotifier{
   int index;
   String title;
   String description;
   bool reached;
   int score;

  TaskData(this.index, this.title, this.description, int reach, this.score)
      : reached = (reach == 1) ? true : false;


  void didupdate(String titl,String descriptio,int reach, ){

    title=titl;
    description=descriptio;
    reached=(reach==1);

    notifyListeners();
  }


}
