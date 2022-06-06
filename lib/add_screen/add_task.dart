import 'package:flutter/material.dart';

class AddTask extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      color: Colors.teal.shade300,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Row(
          children: [ElevatedButton(onPressed: (){

            Navigator.of(context).pop();

          },child: const Text('CANCEL'),),
          
            ElevatedButton(onPressed: (){}, child: Text('add'))
            
            
          ]
        ),
      ),
    );


  }



}