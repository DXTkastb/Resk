import 'package:flutter/material.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';

class TaskData extends ChangeNotifier{
   int index;
   String title;
   String description;
   int reached;
   int score;

  TaskData(this.index, this.title, this.description,  this.reached, this.score);




  Future<void> didupdate(String titl,String descriptio,int reach,) async{

    if(reach==1 && reached==0){
      score++;
    }
    else if(reach==0 && reached==1){
      score--;
    }

    await DatabaseManager.databaseManagerInstance.updateDailyTask(index, titl, descriptio, reach,score).then((value) {
      title=titl;
      description=descriptio;
      reached=reach;
      score=score;
      notifyListeners();
    });

  }



}
