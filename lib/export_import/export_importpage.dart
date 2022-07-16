import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/export_import/exportimportapi.dart';
import '/tasks/task_list_fetch.dart';

class ImportExportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const ImportExport(),
      ),
    );
  }
}

class ImportExport extends StatefulWidget {
  const ImportExport({Key? key}) : super(key: key);

  @override
  State<ImportExport> createState() => _ImportExportState();
}

class _ImportExportState extends State<ImportExport> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            try {
              bool r = await ImportExportApi.api.export(
                  Provider.of<TaskListFetch>(context, listen: false)
                      .listtaskdata);
              if (mounted)
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Export Completed'),
                  duration: Duration(seconds: 2),
                ));
            } catch (_) {
              if (mounted)
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Some Error Occurred. Try Later'),
                  duration: Duration(seconds: 2),
                ));
            }
          },
          child: const Text('Export To Device'),
        ),
        const Divider(
          thickness: 2,
          indent: 45,
          endIndent: 45,
        ),
        const ExportColumn()
      ],
    );
  }
}

class ExportColumn extends StatefulWidget {
  const ExportColumn({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExportColumnState();
  }
}

class ExportColumnState extends State<ExportColumn> {
  bool fileAdded = false;
  List myTask = [];

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onLongPress: () {
            setState(() {
              myTask = [];
              fileAdded = false;
            });
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all(
                fileAdded ? Colors.green.shade400 : Colors.blue),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius:BorderRadius.circular(30) )),
          ),
          onPressed: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (!fileAdded) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Reading file. Please don\'t close app.'),
                duration: Duration(hours: 1),
              ));
              try {
                myTask = jsonDecode(await ImportExportApi.api.tt()) as List;

                if (mounted) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('File Uploaded'),
                  ));

                  setState(() {
                    fileAdded = true;
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File not selected')));
              }
            } else {
              for (var element in myTask) {
                String title = element['title'] as String;
                String description = element['description'] as String;
                int score = element['score'] as int;
                int rem = element['rem'] as int;
                await Provider.of<TaskListFetch>(context, listen: false)
                    .addTask(title, description, rem, score);
              }
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              }
            }
          },
          child: Text(
              (fileAdded) ? ('Add Tasks From File') : ('Import From Device')),
        )
      ],
    );
  }
}
