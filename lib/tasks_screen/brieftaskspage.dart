import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/drawer/alert_d.dart';

import '../buttons/del_button.dart';
import '../buttons/done_button.dart';
import '../dbhelper/databaseManager.dart';
import '../tasks/btask_list_fetch.dart';
import '../tasks/btaskdata.dart';

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
                  });
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
          color: Colors.teal.shade100,
          margin: const EdgeInsets.only(left: 17, right: 17, top: 15),
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
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
                                  builder: (_) => CustomAlertD(
                                          Colors.teal.shade100, () {
                                        () {
                                          Provider.of<BtaskListFetch>(context,
                                                  listen: false)
                                              .removeTask(bTaskData)
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        };
                                      }));

                              // async {
                            }, Colors.teal.shade800),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: (bTaskData.days > 0)
                          ? DaysPoints(bTaskData.days, bTaskData.done)
                          : const SizedBox(),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}

class DaysPoints extends StatelessWidget {
  final bool done;
  final int days;

  const DaysPoints(this.days, this.done);

  List<Widget> getWids() {
    List<Widget> list = [];

    for (int i = 1; i <= days && i < 4; i++) {
      list.add(Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.yellow,
        ),
      ));
    }
    if (days > 4) {
      list.add(Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            '+${days - 4}',
            style: const TextStyle(fontSize: 12),
          )));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: (!done) ? Colors.red : Colors.green,
          ),
        ),
        ...getWids()
      ],
    );
  }
}
