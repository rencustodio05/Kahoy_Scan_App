class ScanHistory {
  const ScanHistory({
    required this.id,
    this.speciesId,
    required this.imagePath,
    required this.confidenceScore,
    required this.timestamp,
  });

  final String id;
  final String? speciesId;
  final String imagePath;

  /// Model confidence in the range 0–1.
  final double confidenceScore;
  final DateTime timestamp;
}
