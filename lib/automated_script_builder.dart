import 'dart:developer';
import 'dart:io';
import 'package:automated_script_builder/iautomated_script_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InteractionRecorder implements IInteractionRecorder {
  DateTime? _idFile;
  static int? fileCode = 1;

  @override
  Future<void> logInteraction(String interaction, String key) async {
    _idFile ??= DateTime.now();
    log(_idFile.toString());
    await _writeLogToFile(interaction, key);
  }

  Future<void> _writeLogToFile(String interaction, String key) async {
    if (await Permission.storage.request().isGranted) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final downloadDir = Directory('/storage/emulated/0/Download/Logger');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }

        final now = DateTime.now();
        final formattedDate = DateFormat('dd-MM-yyyy').format(now);
        final path = '${downloadDir.path}/${formattedDate}_log($fileCode).txt';
        final file = File(path);

        log('Logging interaction to: $path');

        if (key != "") {
          await file.writeAsString('$interaction: $key\n',
              mode: FileMode.append);
        } else {
          log("Key cant null");
        }
      } else {
        log('Could not get the external storage directory');
      }
    } else {
      log('Storage permission not granted');
    }
  }

  @override
  Future<void> initInteractionRecorder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int code = await _getExternalCounter(prefs);
    if (code == 0) {
      await prefs.setInt('interaction_log', 1);
    } else {
      await prefs.setInt('interaction_log', code++);
      fileCode = code++;
    }
  }

  Future<int> _getExternalCounter(SharedPreferences prefs) async {
    final int? counter = prefs.getInt('interaction_log');
    return counter ?? 0;
  }
}
