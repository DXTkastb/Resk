import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../tasks/taskData.dart';

class ImportExportApi {
  static late final Future<Directory> directory;
  static String latestFile = '';
  ImportExportApi._constructor();

  static final api = ImportExportApi._constructor();

  Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    String todayDate = DateFormat('yMMddHms').format(DateTime.now());

    final path = await localPath();
    String finalString = '/storage/emulated/0/Download/dtask_$todayDate.json';
    latestFile = finalString;
    return File(finalString).create(recursive: true);
  }

  Future<String> export(List<TaskData> listData) async {
    final file = await _localFile;
    try {
      await file.writeAsString(jsonEncode(listData), mode: FileMode.append);
    } catch (_) {
      return '';
    }
    return latestFile;
  }

  Future<File?> get _localFile2 async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    }
    return null;
  }

  Future<String> tt() async {
    final file = await _localFile2;
    String str = await file!.readAsString();
    return str;
  }
}
