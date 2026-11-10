import 'package:flutter/foundation.dart';

import '../mock/mock_data.dart';
import '../models/scan_history.dart';
import '../models/species.dart';

/// Iisang pinagkukunan ng Species at ScanHistory sa buong app (nasa memory muna).
/// Sa susunod na hakbang, papalitan ng SQLite ang loob nito.
class KahoyStore extends ChangeNotifier {
  KahoyStore._();
  static final KahoyStore instance = KahoyStore._();

  /// Gawing true para masubukan ang Empty State, tapos i-restart ang app.
  static const bool startWithEmptyHistory = false;

  final List<Species> _species = List.of(MockData.species);
  final List<ScanHistory> _scans =
      startWithEmptyHistory ? <ScanHistory>[] : List.of(MockData.scans);

  /// Species na lumalabas sa Catalog (hindi kasama ang Archived).
    List<Species> get activeSpecies =>
    _species.where((s) => s.isActive).toList(growable: false);

  /// Pinakabago sa itaas.
  List<ScanHistory> get scans {
    final list = List<ScanHistory>.of(_scans);
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Species? speciesById(String? id) {
    if (id == null) return null;
    for (final s in _species) {
      if (s.id == id) return s;
    }
    return null;
  }

  Species? speciesByCommonName(String name) {
    final q = name.trim().toLowerCase();
    for (final s in _species) {
      if (s.commonName.toLowerCase() == q) return s;
    }
    return null;
  }

  void addScan(ScanHistory scan) {
    _scans.add(scan);
    notifyListeners();
  }
}
