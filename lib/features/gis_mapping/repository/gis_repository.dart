import 'package:latlong2/latlong.dart';
import '../model/tree_location_model.dart';

abstract class GISRepository {
  Future<List<TreeLocationModel>> getNearbyTrees(LatLng center, double radiusKm);
  Future<void> tagTree(TreeLocationModel tree);
  Future<List<TreeLocationModel>> getAllTreeLocations();
}

class GISRepositoryImpl implements GISRepository {
  @override
  Future<List<TreeLocationModel>> getNearbyTrees(LatLng center, double radiusKm) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockTreeLocations();
  }

  @override
  Future<void> tagTree(TreeLocationModel tree) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, this would hit the API.
  }

  @override
  Future<List<TreeLocationModel>> getAllTreeLocations() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockTreeLocations();
  }

  List<TreeLocationModel> _mockTreeLocations() {
    return [
      TreeLocationModel(
        id: 'TREE-101',
        species: 'Deodar',
        position: const LatLng(30.3165, 78.0322),
        capturedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TreeLocationModel(
        id: 'TREE-102',
        species: 'Sal',
        position: const LatLng(30.3180, 78.0350),
        capturedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      TreeLocationModel(
        id: 'TREE-103',
        species: 'Teak',
        position: const LatLng(30.3150, 78.0300),
        capturedAt: DateTime.now().subtract(const Duration(days: 1)),
        isFlagged: true,
      ),
      TreeLocationModel(
        id: 'TREE-104',
        species: 'Oak',
        position: const LatLng(30.3200, 78.0400),
        capturedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}
