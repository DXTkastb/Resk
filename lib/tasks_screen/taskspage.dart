import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Card(
            elevation: 6,
            color: Colors.teal.shade100,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Title'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Description'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('status-score'),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.green,
            margin: const EdgeInsets.all(10),
            height: 50,
          ),
        ],
      ),
    );
  }
}
