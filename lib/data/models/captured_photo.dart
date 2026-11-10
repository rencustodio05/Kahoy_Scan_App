import 'dart:typed_data';

class CapturedPhoto {
  const CapturedPhoto({
    required this.bytes,
    required this.fileName,
    required this.byteSize,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final String fileName;
  final int byteSize;
  final int width;
  final int height;

  String get sizeLabel {
    final mb = byteSize / (1024 * 1024);
    if (mb >= 1) {
      return '${mb.toStringAsFixed(1)} MB';
    }
    final kb = byteSize / 1024;
    return '${kb.toStringAsFixed(0)} KB';
  }

  String get dimensionLabel => '$width x $height';

  String get metaLabel => '$sizeLabel · $dimensionLabel';
}
