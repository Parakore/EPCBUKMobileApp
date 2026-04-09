import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../model/tree_location_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

abstract class GISRepository {
  Future<List<TreeLocationModel>> getNearbyTrees(LatLng center, double radiusKm);
  Future<void> tagTree(TreeLocationModel tree);
  Future<List<TreeLocationModel>> getAllTreeLocations();
}

class GISRepositoryImpl implements GISRepository {
  final Dio dio;

  GISRepositoryImpl(this.dio);

  @override
  Future<List<TreeLocationModel>> getNearbyTrees(
      LatLng center, double radiusKm) async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockTreeLocations();
    }

    try {
      final response = await dio.get(
        ApiEndpoints.gisMarkers,
        queryParameters: {
          'lat': center.latitude,
          'lng': center.longitude,
          'radius': radiusKm,
        },
      );
      final List<dynamic> data = response.data;
      return data.map((e) => TreeLocationModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<void> tagTree(TreeLocationModel tree) async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return;
    }

    try {
      await dio.post(ApiEndpoints.gisMarkers, data: tree.toJson());
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<List<TreeLocationModel>> getAllTreeLocations() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockTreeLocations();
    }

    try {
      final response = await dio.get(ApiEndpoints.gisMarkers);
      final List<dynamic> data = response.data;
      return data.map((e) => TreeLocationModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
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

