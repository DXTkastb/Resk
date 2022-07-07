import 'package:flutter/material.dart';

class Functions {
  //check d1 is after d2
  static bool compareDates(DateTime d1, DateTime d2) {
    if (d1.year > d2.year) return true;
    if (d1.month > d2.month) return true;
    if (d1.month == d2.month && d1.day > d2.day) return true;
    return false;
  }

  static String getTimeFromInteger(int value) {
    String dummy = '';
    if (value > 2359) return dummy;

    int hours = value ~/ 100;
    int minutes = (value % 100);
    if (hours > 12) hours = hours - 12;

    if (hours < 10)
      dummy = ' 0$hours';
    else
      dummy = ' $hours';
    if (minutes < 10)
      dummy = dummy + ':0$minutes';
    else
      dummy = dummy + ':$minutes';

    if(value>1159)
      dummy=dummy+' pm';
    else
      dummy =dummy + ' am';
    return dummy;
  }

  static void removeAnyScaffoldSnack(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
