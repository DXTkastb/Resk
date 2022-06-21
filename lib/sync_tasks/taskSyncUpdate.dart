import 'package:flutter/material.dart';

class SyncTaskUpdate extends ChangeNotifier{
  bool updateCall=false;

  void syncUpdate(bool call){
    updateCall=call;
    notifyListeners();
  }

  void noUpdate(){
    updateCall=false;
  }

}