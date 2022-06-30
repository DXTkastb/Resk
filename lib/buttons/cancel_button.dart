import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  void Function()? onpressed;

  CancelButton(this.onpressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
        onPressed: onpressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStateProperty.all(Colors.blueGrey.shade200),
          // maximumSize: MaterialStateProperty.all(const Size(50, 50)),
          minimumSize: MaterialStateProperty.all(const Size(80, 35)),
        ),
        child: const Text(
          'cancel',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ));
  }
}
