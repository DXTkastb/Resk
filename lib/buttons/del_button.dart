import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onpressed;
  final void Function()? longPress;
  final Color color;
  final bool withText;

   const DeleteButton(this.onpressed, this.color,this.longPress,[this.withText=false,]);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onLongPress: longPress,
        onPressed: onpressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStateProperty.all(color),
          // maximumSize: MaterialStateProperty.all(const Size(50, 50)),
          minimumSize: MaterialStateProperty.all( Size((withText)?80:35, 35)),
        ),
        child: (withText)?const Text('delete'):const Icon(Icons.delete, size: 13, color: Colors.white));
  }
}
