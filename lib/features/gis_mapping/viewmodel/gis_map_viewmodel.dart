import 'dart:async';
import 'package:epcbuk_mobile_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../model/tree_location_model.dart';
import '../repository/gis_repository.dart';

class GISMapState {
  final List<TreeLocationModel> cachedTrees;
  final LatLng currentCenter;
  final double currentZoom;
  final bool isLoading;

  GISMapState({
    this.cachedTrees = const [],
    this.currentCenter = const LatLng(30.3165, 78.0322), // Dehradun default
    this.currentZoom = 13.0,
    this.isLoading = false,
  });

  GISMapState copyWith({
    List<TreeLocationModel>? cachedTrees,
    LatLng? currentCenter,
    double? currentZoom,
    bool? isLoading,
  }) {
    return GISMapState(
      cachedTrees: cachedTrees ?? this.cachedTrees,
      currentCenter: currentCenter ?? this.currentCenter,
      currentZoom: currentZoom ?? this.currentZoom,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GISMapViewModel extends AsyncNotifier<GISMapState> {
  late final GISRepository _repository;

  @override
  FutureOr<GISMapState> build() async {
    _repository = ref.watch(gisRepositoryProvider);
    return _loadTrees();
  }

  Future<GISMapState> _loadTrees() async {
    final trees = await _repository.getAllTreeLocations();
    return GISMapState(cachedTrees: trees);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadTrees());
  }

  void updateCenter(LatLng newCenter) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(currentCenter: newCenter));
  }

  void updateZoom(double newZoom) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(currentZoom: newZoom));
  }
}
