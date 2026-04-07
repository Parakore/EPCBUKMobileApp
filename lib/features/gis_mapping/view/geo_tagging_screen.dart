import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../providers/providers.dart';

class GeoTaggingScreen extends ConsumerStatefulWidget {
  const GeoTaggingScreen({super.key});

  @override
  ConsumerState<GeoTaggingScreen> createState() => _GeoTaggingScreenState();
}

class _GeoTaggingScreenState extends ConsumerState<GeoTaggingScreen> {
  final TextEditingController _speciesController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _speciesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taggingState = ref.watch(geoTaggingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pin New Asset'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(30.3165, 78.0322),
                    initialZoom: 15.0,
                    onTap: (tapPosition, point) {
                      ref
                          .read(geoTaggingViewModelProvider.notifier)
                          .selectManualPosition(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.epcbuk.mobile_app',
                    ),
                    if (taggingState.selectedPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: taggingState.selectedPosition!,
                            width: 60,
                            height: 60,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () => ref
                        .read(geoTaggingViewModelProvider.notifier)
                        .getCurrentLocation()
                        .then((_) {
                      if (taggingState.selectedPosition != null) {
                        _mapController.move(taggingState.selectedPosition!, 16);
                      }
                    }),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.my_location,
                        color: AppTheme.primaryGreen),
                  ),
                ),
                if (taggingState.isRecordingLocation)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Asset Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      labelText: 'Tree Species',
                      hintText: 'e.g. Deodar, Banyan, etc.',
                      controller: _speciesController,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Evidence Photos',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    _buildImagePicker(ref, taggingState),
                    const SizedBox(height: 12),
                    if (taggingState.selectedPosition != null)
                      Text(
                        'Location: ${taggingState.selectedPosition!.latitude.toStringAsFixed(6)}, ${taggingState.selectedPosition!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      )
                    else
                      const Text(
                        'Tap on map or use GPS to set location',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Confirm and Save Asset',
                      onPressed: taggingState.selectedPosition == null ||
                              taggingState.isRecordingLocation
                          ? null
                          : () async {
                              final success = await ref
                                  .read(geoTaggingViewModelProvider.notifier)
                                  .saveTag(_speciesController.text);
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Asset tagged successfully!')),
                                );
                                Navigator.pop(context);
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(WidgetRef ref, dynamic state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _actionButton(Icons.camera_alt, 'Camera', () {
              ref
                  .read(geoTaggingViewModelProvider.notifier)
                  .pickImage(ImageSource.camera);
            }),
            const SizedBox(width: 8),
            _actionButton(Icons.photo_library, 'Gallery', () {
              ref
                  .read(geoTaggingViewModelProvider.notifier)
                  .pickImage(ImageSource.gallery);
            }),
          ],
        ),
        if (state.pickedImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.pickedImages.length,
              itemBuilder: (context, index) {
                return _imageThumbnail(ref, state.pickedImages[index], index);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: AppTheme.primaryGreen),
        label: Text(label,
            style: const TextStyle(fontSize: 12, color: AppTheme.primaryGreen)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.primaryGreen),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _imageThumbnail(WidgetRef ref, File file, int index) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => ref
                .read(geoTaggingViewModelProvider.notifier)
                .removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }
}
