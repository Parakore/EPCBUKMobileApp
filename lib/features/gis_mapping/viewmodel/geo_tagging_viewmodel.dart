import 'dart:async';
import 'dart:io';
import 'package:epcbuk_mobile_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../model/tree_location_model.dart';

class GeoTaggingState {
  final LatLng? selectedPosition;
  final bool isRecordingLocation;
  final List<File> pickedImages;
  final String? error;

  GeoTaggingState({
    this.selectedPosition,
    this.isRecordingLocation = false,
    this.pickedImages = const [],
    this.error,
  });

  GeoTaggingState copyWith({
    LatLng? selectedPosition,
    bool? isRecordingLocation,
    List<File>? pickedImages,
    String? error,
  }) {
    return GeoTaggingState(
      selectedPosition: selectedPosition ?? this.selectedPosition,
      isRecordingLocation: isRecordingLocation ?? this.isRecordingLocation,
      pickedImages: pickedImages ?? this.pickedImages,
      error: error,
    );
  }
}

class GeoTaggingViewModel extends AutoDisposeNotifier<GeoTaggingState> {
  @override
  GeoTaggingState build() {
    return GeoTaggingState();
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(isRecordingLocation: true, error: null);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      Position position = await Geolocator.getCurrentPosition();
      state = state.copyWith(
        selectedPosition: LatLng(position.latitude, position.longitude),
        isRecordingLocation: false,
      );
    } catch (e) {
      state = state.copyWith(isRecordingLocation: false, error: e.toString());
    }
  }

  void selectManualPosition(LatLng position) {
    state = state.copyWith(selectedPosition: position);
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(imageQuality: 70, source: source);
    if (image != null) {
      state = state.copyWith(
        pickedImages: [...state.pickedImages, File(image.path)],
      );
    }
  }

  void removeImage(int index) {
    final newList = List<File>.from(state.pickedImages)..removeAt(index);
    state = state.copyWith(pickedImages: newList);
  }

  Future<bool> saveTag(String species) async {
    if (state.selectedPosition == null) return false;

    final tree = TreeLocationModel(
      id: 'TREE-${DateTime.now().millisecondsSinceEpoch}',
      species: species,
      position: state.selectedPosition!,
      capturedAt: DateTime.now(),
    );

    await ref.read(gisRepositoryProvider).tagTree(tree);

    // Refresh the map view
    ref.read(gisMapViewModelProvider.notifier).refresh();

    return true;
  }
}
