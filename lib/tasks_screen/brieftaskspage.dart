import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/dbhelper/databaseManager.dart';
import 'package:reminder_app/tasks/btask_list_fetch.dart';
import 'package:reminder_app/tasks/btaskdata.dart';

class BriefTaskPage extends StatelessWidget {
  final Future btasklist;

  const BriefTaskPage(this.btasklist);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: btasklist,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<BtaskListFetch>(builder: (context, blist, _) {
              return ListView(
                children: [
                  ...blist.listtaskdata.map((e) {
                    return ChangeNotifierProvider<BTaskData>.value(value: e,
                    builder: (ctx,element){
                      return BTaskCard();
                    },
                    );
                  }).toList(),
                ],
              );
            });
          }
          return const CircularProgressIndicator();
        });
  }
}

class BTaskCard extends StatelessWidget {



  Future<void> updateTask(int id, bool done) async {
    await DatabaseManager.databaseManagerInstance
        .updateBreifTask(id, !done)
        .then((value) {

    });
  }

  Color getColor(bool d) {
    if (d) return Colors.blue.shade500;
    return Colors.blue.shade200;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<BTaskData>(
      builder: (ctx,bTaskData,child){
        return Container(
          margin: const EdgeInsets.all(10),
          color: getColor(bTaskData.done),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(bTaskData.title),
              Text((bTaskData.done) ? 'done' : 'unfinished'),
              ElevatedButton(
                  onPressed: () {
                    Future.delayed(Duration.zero,() async {
                      await updateTask(bTaskData.id,bTaskData.done);
                      bTaskData.onUpdate();
                    });
                    
                  },
                  child: const Text('toggle'))
            ],
          ),
        );
      },
    );
  }
}
