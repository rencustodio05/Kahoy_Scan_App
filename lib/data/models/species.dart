class Species {
  const Species({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.habitat,
    required this.uses,
    required this.imagePath,
    required this.status,
    required this.inModel,
    required this.updatedAt,
    this.highlight,
    this.gallery = const [],
  });

  final String id;
  final String commonName;
  final String scientificName;
  final String description;
  final String habitat;
  final String uses;

  /// Pangunahing larawan (asset path). Ginagamit sa Catalog at History.
  final String imagePath;

  /// 'Active' o 'Archived' (ayon sa paper). Hindi ito conservation status.
  final String status;

  /// Kasama ba sa classification model. Walang display sa UI sa ngayon.
  final bool inModel;
  final DateTime updatedAt;

  /// Badge sa ilalim ng pangalan, halimbawa "National Tree of the Philippines".
  final String? highlight;

  /// Karagdagang bark photos para sa carousel. Kapag walang laman, imagePath ang gamit.
  final List<String> gallery;

  bool get isActive => status == 'Active';
}
