import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  void Function()? onpressed;
  final int done;

  DoneButton(this.onpressed, this.done, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
        onPressed: onpressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStateProperty.all(
              (done == 0) ? Colors.red.shade700 : Colors.lightGreen),
          // maximumSize: MaterialStateProperty.all(const Size(81, 50)),
          minimumSize: MaterialStateProperty.all(const Size(0, 35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (done == 1)
                ? Icon(
                    Icons.done,
                    size: 13,
                    color: Colors.deepPurple.shade700,
                  )
                : const SizedBox(),
            const Text(
              ' done',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }
}
