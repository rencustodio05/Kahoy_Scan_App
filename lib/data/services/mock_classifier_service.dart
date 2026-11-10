import 'package:flutter/widgets.dart';

/// Isang "possible species" sa listahan ng Result screen.
class Candidate {
  const Candidate(this.name, this.confidence, {this.thumbnail});

  final String name;
  final double confidence; // 0 hanggang 1
  final ImageProvider? thumbnail;
}

/// Resulta ng classification (mock muna).
class ClassificationResult {
  const ClassificationResult({
    required this.commonName,
    required this.scientificName,
    required this.confidence,
    required this.others,
    required this.note,
  });

  final String commonName;
  final String scientificName;
  final double confidence; // 0 hanggang 1
  final List<Candidate> others;
  final String note;

  bool get isHighConfidence => confidence >= 0.70;
}

/// Pekeng classifier. Papalitan ng TFLite service sa hinaharap.
class MockClassifierService {
  MockClassifierService._();
  static final MockClassifierService instance = MockClassifierService._();

  /// true = 82% na resulta (Result screen)
  /// false = 45% na resulta (Low-Confidence Alert)
  /// Palitan ang value na ito para masubukan ang dalawa.
  bool simulateHighConfidence = true;

  Future<ClassificationResult> classify() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (simulateHighConfidence) {
      return const ClassificationResult(
        commonName: 'Narra',
        scientificName: 'Pterocarpus indicus',
        confidence: 0.82,
        others: [
          Candidate('Mahogany', 0.10),
          Candidate('Molave', 0.05),
          Candidate('Acacia', 0.03),
        ],
        note: 'Narra is the national tree of the Philippines, known for its '
            'reddish-brown heartwood and rough, scaly bark with shallow fissures.',
      );
    }

    return const ClassificationResult(
      commonName: 'Narra',
      scientificName: 'Pterocarpus indicus',
      confidence: 0.45,
      others: [
        Candidate('Mahogany', 0.30),
        Candidate('Molave', 0.15),
        Candidate('Acacia', 0.10),
      ],
      note: '',
    );
  }
}