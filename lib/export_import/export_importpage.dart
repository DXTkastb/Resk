import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/export_import/exportimportapi.dart';

import '../tasks/task_list_fetch.dart';

class ImportExport extends StatelessWidget {
  const ImportExport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(color: Colors.green,
      alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:  [
            TextButton(onPressed: () async {
              // bool r = await ImportExportApi.api.export( Provider.of<TaskListFetch>(context, listen: false).listtaskdata);
              //
              // print(r);
              await ImportExportApi.api.tt();
            }, child:const  Text('export'),),
            const Divider(
              thickness: 2,
              indent: 17,
              endIndent: 17,
            ),Text('a'),
          ],
        ),
      ),
    );
  }


}