import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  void Function()? onpressed;
  final Color color;

  DeleteButton(this.onpressed, this.color);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onpressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStateProperty.all(color),
        // maximumSize: MaterialStateProperty.all(const Size(50, 50)),
        minimumSize: MaterialStateProperty.all(const Size(35, 35)),
        ),
      child: const Icon(Icons.delete,size: 13,color: Colors.white)
    );
  }
}
