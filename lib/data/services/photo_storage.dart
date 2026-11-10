import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

/// Ang path na nagsisimula sa 'assets/' ay asset; ang iba ay file sa device.
ImageProvider imageFromPath(String path) =>
    path.startsWith('assets/') ? AssetImage(path) : FileImage(File(path));

class PhotoStorage {
  PhotoStorage._();

  /// Sine-save ang bark photo sa device at ibinabalik ang path.
  /// Ibinabalik ang '' kapag nabigo (hindi magka-crash ang app).
  static Future<String> save(Uint8List bytes) async {
    try {
      final base = await getApplicationDocumentsDirectory();
      final dir = Directory('${base.path}/scans');
      if (!await dir.exists()) await dir.create(recursive: true);
      final file = File(
        '${dir.path}/scan_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (_) {
      return '';
    }
  }
}
