import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../tasks/taskData.dart';

class ImportExportApi {
  static late final Future<Directory> directory;

  ImportExportApi._constructor();

  static final api = ImportExportApi._constructor();

  Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    String todayDate = DateFormat('yMMdd').format(DateTime.now());

    final path = await localPath();     String finalString ='$path/dtask_$todayDate.json';
    print(finalString);
    return File(finalString).create(recursive: true);
  }

  Future<bool> export(List<TaskData> listData) async {
    final file = await _localFile;
    try {
      await file.writeAsString(
          jsonEncode(listData.map((e) => jsonEncode(e)).toList()),
          mode: FileMode.append);
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<File> get _localFile2 async {
    return File('/data/user/0/com.example.reminder_app/app_flutter/dtask_20220716.json').create(recursive: true);
  }
  Future<void> tt() async{
    final file = await _localFile2;

    String str = await file.readAsString();
    print(str);
  }


}
