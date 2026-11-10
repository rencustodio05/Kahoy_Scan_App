import '../models/scan_history.dart';
import '../models/species.dart';
import '../store/kahoy_store.dart';

abstract class KahoyRepository {
  Future<List<Species>> getSpecies();

  Future<Species?> getSpeciesById(String id);

  Future<List<ScanHistory>> getRecentScans();
}

class MockKahoyRepository implements KahoyRepository {
  const MockKahoyRepository();

  @override
  Future<List<Species>> getSpecies() async => KahoyStore.instance.activeSpecies;

  @override
  Future<Species?> getSpeciesById(String id) async =>
      KahoyStore.instance.speciesById(id);

  @override
  Future<List<ScanHistory>> getRecentScans() async => KahoyStore.instance.scans;
}
