import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../store/kahoy_store.dart';
import 'classification_result.dart';

/// Mapping ng class name sa model -> id ng species sa catalog.
/// Kapag nagdagdag ng species sa model, dagdagan din ito.
const Map<String, String> kLabelToSpeciesId = {
  'Big-leafed_Mahogany': 'mahogany',
  'Binunga': 'binunga',
  'Raintree': 'acacia',
  'Melina': 'gmelina',
  'Smooth_Narra': 'narra',
};

/// Totoong on-device classifier (MobileNetV2 INT8).
///
/// Mga nakuha sa model:
///  - input : uint8 [1,224,224,3], quantization (1.0, 0)  -> RAW RGB 0-255
///  - output: uint8 [1,N], scale 0.00390625, zero point 0 -> probability = value / 256
///    (softmax ay nasa loob na ng model. HUWAG mag-softmax ulit.)
class TfliteClassifierService {
  TfliteClassifierService._();
  static final TfliteClassifierService instance = TfliteClassifierService._();

  static const String _modelAsset =
      'assets/model/kahoy_scan_mobilenetv2_int8.tflite';
  static const String _labelsAsset = 'assets/model/class_names.json';
  static const int _size = 224;
  static const double _outputScale = 0.00390625;

  Interpreter? _interpreter;
  List<String> _labels = const [];

  /// Oras ng huling inference (ms). Para sa Section 2.6 ng paper.
  int lastInferenceMs = 0;

  Future<void> _ensureLoaded() async {
    if (_interpreter != null) return;
    final json = await rootBundle.loadString(_labelsAsset);
    _labels = (jsonDecode(json) as List).cast<String>();
    _interpreter = await Interpreter.fromAsset(_modelAsset);
  }

  /// Hindi nagtatapon ng error. Kapag nabigo, ibinabalik ang resulta na may 0%
  /// confidence (lalabas ang Low-Confidence Alert) at may debugPrint.
  Future<ClassificationResult> classify(Uint8List imageBytes) async {
    try {
      await _ensureLoaded();
      final sw = Stopwatch()..start();

      var image = img.decodeImage(imageBytes);
      if (image == null) throw StateError('Hindi mabasa ang larawan.');
      image = img.bakeOrientation(image); // ayusin ang pag-ikot ng camera photo
      final resized = img.copyResize(
        image,
        width: _size,
        height: _size,
        interpolation: img.Interpolation.linear,
      );

      final input = Uint8List(_size * _size * 3);
      var i = 0;
      for (var y = 0; y < _size; y++) {
        for (var x = 0; x < _size; x++) {
          final p = resized.getPixel(x, y);
          input[i++] = p.r.toInt();
          input[i++] = p.g.toInt();
          input[i++] = p.b.toInt();
        }
      }

      final output = List.filled(
        _labels.length,
        0,
      ).reshape([1, _labels.length]);
      _interpreter!.run(input.buffer, output);

      final raw = (output[0] as List).cast<int>();
      final probs = [for (final v in raw) v * _outputScale];
      sw.stop();
      lastInferenceMs = sw.elapsedMilliseconds;
      debugPrint('[Kahoy] inference: $lastInferenceMs ms, raw: $raw');

      final order = List<int>.generate(probs.length, (k) => k)
        ..sort((a, b) => probs[b].compareTo(probs[a]));
      final top = order.first;

      return ClassificationResult(
        commonName: _nameFor(_labels[top]),
        scientificName: _scientificFor(_labels[top]),
        confidence: probs[top],
        others: [
          for (final k in order.skip(1).take(3))
            Candidate(_nameFor(_labels[k]), probs[k]),
        ],
        note: _noteFor(_labels[top]),
      );
    } catch (e, st) {
      debugPrint('[Kahoy] classify error: $e\n$st');
      return const ClassificationResult(
        commonName: '',
        scientificName: '',
        confidence: 0,
        others: [],
        note: '',
      );
    }
  }

  String _nameFor(String label) {
    final s = KahoyStore.instance.speciesById(kLabelToSpeciesId[label]);
    return s?.commonName ?? label.replaceAll('_', ' ');
  }

  String _scientificFor(String label) {
    final s = KahoyStore.instance.speciesById(kLabelToSpeciesId[label]);
    return s?.scientificName ?? '';
  }

  String _noteFor(String label) {
    final s = KahoyStore.instance.speciesById(kLabelToSpeciesId[label]);
    if (s == null) return '';
    final d = s.description;
    final cut = d.indexOf('. ');
    return cut == -1 ? d : d.substring(0, cut + 1);
  }
}
