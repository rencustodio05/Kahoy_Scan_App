import '../models/scan_history.dart';
import '../models/species.dart';

abstract final class MockData {
  static const String narraImage = 'assets/images/bark_narra.png';
  static const String mahoganyImage = 'assets/images/bark_mahogany.png';
  static const String acaciaImage = 'assets/images/bark_acacia.png';

  // PAALALA: Sample text ang karamihan maliban sa Narra (galing sa Figma).
  // Palitan ng faculty-verified na nilalaman bago ang final na bersyon.
  static final List<Species> species = [
    Species(
      id: 'narra',
      commonName: 'Narra',
      scientificName: 'Pterocarpus indicus',
      highlight: 'National Tree of the Philippines',
      description:
          'Narra bark is grayish-brown, rough and scaly, with shallow '
          'longitudinal fissures. The inner bark exudes a reddish sap when cut. '
          'Mature trees develop a buttressed trunk base, and the crown is broad '
          'and umbrella-shaped, providing dense shade.',
      habitat:
          'Commonly found in lowland and second-growth forests across the '
          'Philippines, from sea level up to 500 meters elevation. Narra is '
          'tolerant of various soil types, including sandy and clay soils, and '
          'thrives in both wet and dry seasonal climates.',
      uses:
          'Prized for furniture, flooring and woodcarving due to its durable, '
          'reddish-brown heartwood that polishes to a fine finish. Narra is also '
          'widely planted along roads, parks and residential areas as an '
          'ornamental shade tree.',
      imagePath: narraImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 10, 20),
    ),
    Species(
      id: 'mahogany',
      commonName: 'Mahogany',
      scientificName: 'Swietenia macrophylla',
      description:
          'A large tropical hardwood with dark reddish-brown bark and commercially valuable timber.',
      habitat: 'Plantations and secondary forests across Mindanao',
      uses: 'Cabinetry, construction lumber, and shade trees',
      imagePath: mahoganyImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 10, 18),
    ),
    Species(
      id: 'molave',
      commonName: 'Molave',
      scientificName: 'Vitex parviflora',
      description:
          'A sturdy native hardwood with a rugged bark, historically prized for posts and shipbuilding.',
      habitat: 'Dry limestone forests and open woodlands',
      uses: 'Heavy construction, railroad ties, and carving',
      imagePath: narraImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 9, 30),
    ),
    Species(
      id: 'acacia',
      commonName: 'Acacia',
      scientificName: 'Samanea saman',
      description:
          'A wide-crowned tree with rough, grayish-brown bark and deep fissures, commonly planted for shade.',
      habitat: 'Parks, roadsides, and open areas in the lowlands',
      uses: 'Shade tree, furniture, and carving',
      imagePath: acaciaImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 10, 15),
    ),
    Species(
      id: 'ipil',
      commonName: 'Ipil',
      scientificName: 'Intsia bijuga',
      description:
          'A coastal hardwood with thick, flaky bark and dense, durable heartwood.',
      habitat: 'Coastal forests and mangrove edges',
      uses: 'Marine construction, flooring, and furniture',
      imagePath: mahoganyImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 9, 22),
    ),
    Species(
      id: 'yakal',
      commonName: 'Yakal',
      scientificName: 'Shorea astylosa',
      description:
          'A Philippine dipterocarp with deeply fissured bark and very hard yellowish timber.',
      habitat: 'Lowland dipterocarp forests of Mindanao',
      uses: 'Heavy construction and high-grade lumber',
      imagePath: acaciaImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 9, 12),
    ),
    Species(
      id: 'gmelina',
      commonName: 'Gmelina',
      scientificName: 'Gmelina arborea',
      description:
          'A widely planted plantation species with relatively smooth, pale bark.',
      habitat: 'Tree farms and community woodlots',
      uses: 'Pulp, light construction, and packing crates',
      imagePath: narraImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 8, 28),
    ),
    Species(
      id: 'teak',
      commonName: 'Teak',
      scientificName: 'Tectona grandis',
      description:
          'A large deciduous tree with fibrous, peeling bark and weather-resistant wood.',
      habitat: 'Plantations in warmer lowland areas',
      uses: 'Outdoor furniture, boat decks, and millwork',
      imagePath: mahoganyImage,
      status: 'Active',
      inModel: true,
      updatedAt: DateTime(2024, 8, 10),
    ),
    Species(
      id: 'kamagong',
      commonName: 'Kamagong',
      scientificName: 'Diospyros blancoi',
      description:
          'Philippine ebony with very dark, dense wood and dark, rough bark.',
      habitat: 'Lowland forests of Luzon, Visayas, and Mindanao',
      uses: 'Luxury furniture, musical instruments, and crafts',
      imagePath: acaciaImage,
      status: 'Active',
      inModel: false,
      updatedAt: DateTime(2024, 7, 18),
    ),
    Species(
      id: 'agoho',
      commonName: 'Agoho',
      scientificName: 'Casuarina equisetifolia',
      description:
          'A coastal needle-leaved tree with furrowed gray bark.',
      habitat: 'Sandy coasts, dunes, and windbreaks',
      uses: 'Windbreaks, fuelwood, and coastal stabilization',
      imagePath: narraImage,
      status: 'Active',
      inModel: false,
      updatedAt: DateTime(2024, 7, 4),
    ),
  ];

  /// Anim na sample scan na galing sa Figma (dalawa ang "No exact match").
  static final List<ScanHistory> scans = [
    ScanHistory(
      id: 'scan-001',
      speciesId: 'narra',
      imagePath: narraImage,
      confidenceScore: 0.82,
      timestamp: DateTime(2024, 10, 24, 14, 15),
    ),
    ScanHistory(
      id: 'scan-002',
      speciesId: 'mahogany',
      imagePath: mahoganyImage,
      confidenceScore: 0.91,
      timestamp: DateTime(2024, 10, 23, 16, 48),
    ),
    ScanHistory(
      id: 'scan-003',
      imagePath: acaciaImage,
      confidenceScore: 0.41,
      timestamp: DateTime(2024, 10, 22, 9, 2),
    ),
    ScanHistory(
      id: 'scan-004',
      speciesId: 'molave',
      imagePath: narraImage,
      confidenceScore: 0.76,
      timestamp: DateTime(2024, 10, 20, 11, 30),
    ),
    ScanHistory(
      id: 'scan-005',
      speciesId: 'acacia',
      imagePath: acaciaImage,
      confidenceScore: 0.88,
      timestamp: DateTime(2024, 10, 18, 7, 52),
    ),
    ScanHistory(
      id: 'scan-006',
      imagePath: mahoganyImage,
      confidenceScore: 0.53,
      timestamp: DateTime(2024, 10, 15, 15, 10),
    ),
  ];
}
