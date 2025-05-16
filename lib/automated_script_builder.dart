import 'dart:developer' show log;
import 'dart:io' show Directory, File, FileMode;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:intl/intl.dart' show DateFormat;
import 'package:lite_storage/lite_storage.dart';
import 'package:path_provider/path_provider.dart' show getExternalStorageDirectory;
import 'package:permission_handler/permission_handler.dart'
    show FuturePermissionStatusGetters, Permission, PermissionActions, PermissionCheckShortcuts;

import 'iautomated_script_builder.dart';

class InteractionRecorder implements IInteractionRecorder {
  DateTime? _idFile;
  static int _fileCode = 1;
  bool _isInitialized = false;

  @override
  Future<void> initInteractionRecorder() async {
    if (kIsWeb) return log('Web platform not supported', name: 'Logger');

    WidgetsFlutterBinding.ensureInitialized();
    await _requestFilePermissions();
    await LiteStorage.init('Logger');
    int code = await _getExternalCounter();
    if (code == 0) {
      LiteStorage.write('interaction_log', 1);
    } else {
      int newCode = code + 1;
      LiteStorage.write('interaction_log', newCode);
      _fileCode = newCode;
    }
    _isInitialized = true;
  }

  @override
  Future<void> logInteraction(String interaction, String key) async {
    if (kIsWeb) return;
    if (!_isInitialized) return log('Logger not initialized | Need to Initialize first', name: 'Logger');

    _idFile ??= DateTime.now();
    await _writeLogToFile(interaction, key);
  }

  Future<void> _writeLogToFile(String interaction, String key) async {
    if (await _requestFilePermissions()) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final downloadDir = Directory('/storage/emulated/0/Download/Logger');
        if (!await downloadDir.exists()) await downloadDir.create(recursive: true);

        final now = DateTime.now();
        final formattedDate = DateFormat('dd-MM-yyyy').format(now);
        final path = '${downloadDir.path}/${formattedDate}_log($_fileCode).txt';
        final file = File(path);

        log('Logging interaction to: $path', name: 'Logger');

        if (key != "") {
          await file.writeAsString('$interaction: $key\n', mode: FileMode.append);
        } else {
          log("Key cant null", name: 'Logger');
        }
      } else {
        log('Could not get the external storage directory', name: 'Logger');
      }
    } else {
      log('Storage permission not granted', name: 'Logger');
    }
  }

  Future<int> _getExternalCounter() async {
    final int? counter = LiteStorage.read('interaction_log');
    return counter ?? 0;
  }

  Future<bool> _requestFilePermissions() async {
    if (await Permission.manageExternalStorage.isGranted) return true;
    if (await Permission.manageExternalStorage.request().isGranted) return true;
    if (await Permission.storage.request().isGranted) return true;

    log('Storage permissions not granted, unable to proceed', name: 'Logger');
    return false;
  }
}
