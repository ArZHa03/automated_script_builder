import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logger {
  DateTime? _idFile;
  static int? _fileCode = 1;
  bool _isInitialized = false;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _requestFilePermissions();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int code = await _getExternalCounter(prefs);
    if (code == 0) {
      await prefs.setInt('interaction_log', 1);
    } else {
      int newCode = code + 1;
      await prefs.setInt('interaction_log', newCode);
      _fileCode = newCode;
    }
    _isInitialized = true;
  }

  Future<void> logging(String interaction, String key) async {
    if (!_isInitialized) return log('Logger not initialized', name: 'Logger');

    _idFile ??= DateTime.now();
    log(_idFile.toString(), name: 'Logger');
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

  Future<int> _getExternalCounter(SharedPreferences prefs) async {
    final int? counter = prefs.getInt('interaction_log');
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
