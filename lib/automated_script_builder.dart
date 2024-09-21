import 'dart:developer';
import 'dart:io';
import 'package:automated_script_builder/iautomated_script_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class InteractionRecorder implements IInteractionRecorder {
  DateTime? _idFile;

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

        final path = '${downloadDir.path}/interaction_log.txt';
        final file = File(path);

        log('Logging interaction to: $path');

        if (key != "" || key != null) {
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

  Future<void> deleteLogFile() async {
    if (await Permission.storage.request().isGranted) {
      final directory = Directory('/storage/emulated/0/Download/Logger');
      final path = '${directory.path}/interaction_log.txt';
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
        log('Deleted file: $path');
      } else {
        log('File does not exist: $path');
      }
    } else {
      log('Storage permission not granted');
    }
  }
}
