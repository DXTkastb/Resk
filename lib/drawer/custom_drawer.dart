import 'package:flutter/material.dart';

class CustomDrawerColumn extends StatelessWidget {
  final double height;

  const CustomDrawerColumn(this.height);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // const Expanded(child: SizedBox()),
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 14),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/reminderpage');
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
              backgroundColor:
                  MaterialStateProperty.all(Colors.deepOrange.shade700),
              foregroundColor:
                  MaterialStateProperty.all(Colors.deepOrange.shade200),
              overlayColor:
                  MaterialStateProperty.all(Colors.deepOrange.shade400),
            ),
            child: Padding(
                padding: EdgeInsets.only(top: height / 50, bottom: height / 50),
                child: Text(
                  'Reminders',
                  style: TextStyle(
                      fontSize: height / 43,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )),
          ),
        ),

        const Divider(
          thickness: 2,
          indent: 17,
          endIndent: 17,
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.deepOrange.shade800],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          margin: const EdgeInsets.only(top: 14),alignment: Alignment.center,
          child: const Text('Coming soon',style : TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold)),
        )),
        Padding(
          padding: const EdgeInsets.only(),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape:
                  MaterialStateProperty.all(const ContinuousRectangleBorder()),
              backgroundColor:
                  MaterialStateProperty.all(Colors.deepOrange.shade800),
              foregroundColor:
                  MaterialStateProperty.all(Colors.deepOrange.shade200),
              overlayColor:
                  MaterialStateProperty.all(Colors.deepOrange.shade400),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'More Stats',
                  style: TextStyle(
                      fontSize: height / 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ],
    );
  }
}
