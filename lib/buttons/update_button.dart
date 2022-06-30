import 'package:flutter/material.dart';

class UpdateButton extends StatelessWidget {
  void Function()? onpressed;

  UpdateButton(
    this.onpressed, {Key? key}
  ) : super(key: key);

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
          minimumSize: MaterialStateProperty.all(const Size(80, 35)),
        ),
        child: const Text(
          'update',
          style: TextStyle(fontSize: 14, color: Colors.deepPurple),
        ));
  }
}

class UpdateButtonIco extends StatelessWidget {
  void Function()? onpressed;

  UpdateButtonIco(this.onpressed, {Key? key}) : super(key: key);

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
      child: Icon(
        Icons.edit,
        size: 13,
        color: Colors.deepPurple.shade700,
      ),
    );
  }
}
