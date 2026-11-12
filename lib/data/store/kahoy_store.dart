import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../mock/mock_data.dart';
import '../models/scan_history.dart';
import '../models/species.dart';

/// Iisang pinagkukunan ng Species at ScanHistory sa buong app.
/// Naka-save sa SQLite sa device (offline, permanente).
/// Ang mga pangalan ng table at column ay ayon sa Tables 15 at 16 ng paper.
class KahoyStore extends ChangeNotifier {
  KahoyStore._();
  static final KahoyStore instance = KahoyStore._();

  static const String _dbName = 'kahoy_scan.db';
  static const int _dbVersion = 1;

  /// Bundled catalog: ang 5 species na na-train. Walang sample scan.
  static const Set<String> _bundledIds = {
    'narra',
    'mahogany',
    'acacia',
    'gmelina',
    'binunga',
  };

  Database? _db;
  List<Species> _species = [];
  List<ScanHistory> _scans = [];

  bool get isInitialized => _db != null;

  /// Tawagin nang isang beses sa main() bago ang runApp().
  Future<void> init() async {
    if (_db != null) return;
    final path = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    await _reload();
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Species (
        SpeciesID TEXT PRIMARY KEY,
        CommonName TEXT NOT NULL,
        ScientificName TEXT NOT NULL,
        Description TEXT,
        Habitat TEXT,
        Uses TEXT,
        ImagePath TEXT,
        Highlight TEXT,
        Status TEXT NOT NULL DEFAULT 'Active',
        InModel INTEGER NOT NULL DEFAULT 0,
        UpdatedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ScanHistory (
        ScanID TEXT PRIMARY KEY,
        SpeciesID TEXT,
        ImagePath TEXT NOT NULL,
        ConfidenceScore REAL NOT NULL,
        Timestamp TEXT NOT NULL,
        FOREIGN KEY (SpeciesID) REFERENCES Species (SpeciesID)
      )
    ''');

    final batch = db.batch();
    for (final s in MockData.species.where((s) => _bundledIds.contains(s.id))) {
      batch.insert('Species', _speciesToRow(s));
    }
    await batch.commit(noResult: true);
  }

  Future<void> _reload() async {
    final db = _db!;
    final speciesRows = await db.query(
      'Species',
      orderBy: 'CommonName COLLATE NOCASE',
    );
    final scanRows = await db.query('ScanHistory');
    _species = speciesRows.map(_speciesFromRow).toList();
    _scans = scanRows.map(_scanFromRow).toList();
    notifyListeners();
  }

  // ---------------------------------------------------------------- Species

  /// Lumalabas sa Catalog ang lahat ng Active na species, kahit wala pang model.
  List<Species> get activeSpecies =>
      _species.where((s) => s.isActive).toList(growable: false);

  Species? speciesById(String? id) {
    if (id == null) return null;
    for (final s in _species) {
      if (s.id == id) return s;
    }
    return null;
  }

  Species? speciesByCommonName(String name) {
    final q = name.trim().toLowerCase().replaceAll('_', ' ');
    for (final s in _species) {
      if (s.commonName.trim().toLowerCase() == q) return s;
    }
    return null;
  }

  /// Para sa Catalog Update Manager sa hinaharap.
  Future<void> upsertSpecies(Species species) async {
    await _db?.insert(
      'Species',
      _speciesToRow(species),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _reload();
  }

  // ------------------------------------------------------------------ Scans

  /// Pinakabago sa itaas.
  List<ScanHistory> get scans {
    final list = List<ScanHistory>.of(_scans);
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> addScan(ScanHistory scan) async {
    _scans.add(scan);
    notifyListeners();
    try {
      await _db?.insert('ScanHistory', {
        'ScanID': scan.id,
        'SpeciesID': scan.speciesId,
        'ImagePath': scan.imagePath,
        'ConfidenceScore': scan.confidenceScore,
        'Timestamp': scan.timestamp.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint('[Kahoy] hindi na-save ang scan: $e');
    }
  }

  // ---------------------------------------------------------------- Mapping

  Map<String, Object?> _speciesToRow(Species s) => {
    'SpeciesID': s.id,
    'CommonName': s.commonName,
    'ScientificName': s.scientificName,
    'Description': s.description,
    'Habitat': s.habitat,
    'Uses': s.uses,
    'ImagePath': s.imagePath,
    'Highlight': s.highlight,
    'Status': s.status,
    'InModel': s.inModel ? 1 : 0,
    'UpdatedAt': s.updatedAt.toIso8601String(),
  };

  Species _speciesFromRow(Map<String, Object?> r) => Species(
    id: r['SpeciesID'] as String,
    commonName: r['CommonName'] as String,
    scientificName: r['ScientificName'] as String,
    description: (r['Description'] as String?) ?? '',
    habitat: (r['Habitat'] as String?) ?? '',
    uses: (r['Uses'] as String?) ?? '',
    imagePath: (r['ImagePath'] as String?) ?? '',
    highlight: r['Highlight'] as String?,
    status: (r['Status'] as String?) ?? 'Active',
    inModel: (r['InModel'] as int? ?? 0) == 1,
    updatedAt: DateTime.parse(r['UpdatedAt'] as String),
  );

  ScanHistory _scanFromRow(Map<String, Object?> r) => ScanHistory(
    id: r['ScanID'] as String,
    speciesId: r['SpeciesID'] as String?,
    imagePath: r['ImagePath'] as String,
    confidenceScore: (r['ConfidenceScore'] as num).toDouble(),
    timestamp: DateTime.parse(r['Timestamp'] as String),
  );
}
