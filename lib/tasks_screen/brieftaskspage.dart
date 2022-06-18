import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../buttons/done_button.dart';
import '../dbhelper/databaseManager.dart';
import '../tasks/btask_list_fetch.dart';
import '../tasks/btaskdata.dart';

import '../buttons/del_button.dart';

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
              if (blist.listtaskdata.isEmpty) {
                return Center(
                  child: Text(
                    'Add Brief Tasks!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }

              return ListView.builder(
                      itemCount: blist.listtaskdata.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider<BTaskData>.value(
                          value: blist.listtaskdata[index],
                          builder: (ctx, element) {
                            return BTaskCard();
                          },
                        );
                      })

                  //   ListView(
                  //   children: [
                  //     const SizedBox(height: 15,),
                  //     ...blist.listtaskdata.map((e) {
                  //       return
                  //         ChangeNotifierProvider<BTaskData>.value(value: e,
                  //       builder: (ctx,element){
                  //         return BTaskCard();
                  //       },
                  //       );
                  //     }).toList(),
                  //   ],
                  // );

                  ;
            });
          }
          return const CircularProgressIndicator();
        });
  }
}

class BTaskCard extends StatelessWidget {
  void removeAnyScaffoldSnack(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  Future<void> updateTask(int id, bool done) async {
    await DatabaseManager.databaseManagerInstance
        .updateBreifTask(id, !done)
        .then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<BTaskData>(
      builder: (ctx, bTaskData, child) {
        return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.teal.shade200,
          margin: const EdgeInsets.only(left: 15, right: 15, top: 12),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bTaskData.title,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    DoneButton(() {
                      Future.delayed(Duration.zero, () async {
                        await updateTask(bTaskData.id, bTaskData.done);
                        bTaskData.onUpdate();
                      });
                    }, (bTaskData.done) ? 1 : 0),
                    const SizedBox(
                      width: 4,
                    ),
                    DeleteButton(() {
                      removeAnyScaffoldSnack(context);
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text('delete task?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<BtaskListFetch>(context,
                                                listen: false)
                                            .removeTask(bTaskData)
                                            .then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: const Text('delete')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('cancel')),
                                ],
                              ));

                      // async {
                    }, Colors.teal.shade800),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
