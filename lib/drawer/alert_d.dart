import 'package:flutter/material.dart';

import '../buttons/cancel_button.dart';
import '../buttons/del_button.dart';

class CustomAlertD extends StatelessWidget {
  final bool isB;

  final Color color;
  final void Function()? onpressed;

  const CustomAlertD(this.color, this.onpressed, [this.isB = true]);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titlePadding: const EdgeInsets.only(top: 30, bottom: 20),
      titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(61, 0, 0, 1.0)),
      title: const Text(
        'Delete Task?',
        textAlign: TextAlign.center,
      ),
      actions: [
        DeleteButton(
            onpressed, (isB) ? Colors.teal.shade900 : Colors.deepPurple,(){
              }, true),
        CancelButton(() {
          Navigator.of(context).pop();
        }),
      ],
    );
  }
}
