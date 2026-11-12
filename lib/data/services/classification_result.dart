import 'package:flutter/widgets.dart';

class Candidate {
  const Candidate(this.name, this.confidence, {this.thumbnail});

  final String name;
  final double confidence;
  final ImageProvider? thumbnail;
}

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
  final double confidence;
  final List<Candidate> others;
  final String note;

  bool get isHighConfidence => confidence >= 0.70;
}
