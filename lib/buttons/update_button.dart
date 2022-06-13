import 'package:flutter/material.dart';

class UpdateButton extends StatelessWidget {
  void Function()? onpressed;
  String? text;

  UpdateButton(this.onpressed, [this.text]);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onpressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        // maximumSize: MaterialStateProperty.all(const Size(50, 50)),
        minimumSize: MaterialStateProperty.all(const Size(35, 35)),
      ),
      child:

        (text!=null)?Text(text!,  style: const TextStyle(fontSize: 14, color: Colors.deepPurple),):   Icon(
          Icons.edit,
          size: 13,
          color: Colors.deepPurple.shade700,
        ),

    );
  }
}
