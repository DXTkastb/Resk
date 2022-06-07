import 'package:flutter/material.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';

class TaskData {
  final int index;
  final String title;
  final String description;
  final bool reached;
  final int score;

  TaskData(this.index, this.title, this.description, int reach, this.score)
      : reached = (reach == 1) ? true : false;




}
