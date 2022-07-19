import 'package:flutter/material.dart';

class CustomDrawerColumn extends StatelessWidget {
  final double height;

  const CustomDrawerColumn(this.height, {Key? key}) : super(key: key);

  ButtonStyle getbuttonstyle(){
    return ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200))),
      backgroundColor:
      MaterialStateProperty.all(Colors.deepOrange.shade700),
      foregroundColor:
      MaterialStateProperty.all(Colors.deepOrange.shade200),
      overlayColor:
      MaterialStateProperty.all(Colors.deepOrange.shade400),
    );
  }

  TextStyle getButtonTextStyle(){
    return TextStyle(
        fontSize: height / 45,
        fontWeight: FontWeight.bold,
        color: Colors.white);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 30, right: 30,),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pushNamed('/reminderpage');
            },
            style: getbuttonstyle(),
            child: Padding(
                padding: EdgeInsets.only(top: height / 50, bottom: height / 50),
                child: Text(
                  'Reminders',
                  style: getButtonTextStyle(),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 14),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/exportimport');
            },
            style: getbuttonstyle(),
            child: Padding(
                padding: EdgeInsets.only(top: height / 50, bottom: height / 50),
                child: Text(
                  'Export / Import',
                  style: getButtonTextStyle(),
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
          margin: const EdgeInsets.only(top: 14),
          alignment: Alignment.center,
          child: const Text('Coming soon',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
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
                  MaterialStateProperty.all(const RoundedRectangleBorder()),
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
