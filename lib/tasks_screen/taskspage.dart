import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tasks/taskData.dart';
import '../tasks/task_list_fetch.dart';
import './taskWid.dart';

class TasksPage extends StatelessWidget {
   final Future tasklist;

   const TasksPage(this.tasklist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: tasklist,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<TaskListFetch>(builder: (ctx, tlist, _) {
            if (tlist.listtaskdata.isEmpty) {
              return Center(
                child: Text(
                  'Add Daily Tasks!',
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            }

            return ListView.builder(
                itemCount: tlist.listtaskdata.length,
                itemBuilder: (ctx, index) {
                  return ChangeNotifierProvider<TaskData>.value(
                    value: tlist.listtaskdata[index],
                    builder: (_, tt) {
                      return const TaskWidget();
                    },
                  );
                });
          });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
