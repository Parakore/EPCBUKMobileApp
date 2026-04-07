import 'package:latlong2/latlong.dart';

class TreeLocationModel {
  final String id;
  final String species;
  final LatLng position;
  final DateTime capturedAt;
  final String? imageUrl;
  final bool isFlagged;

  TreeLocationModel({
    required this.id,
    required this.species,
    required this.position,
    required this.capturedAt,
    this.imageUrl,
    this.isFlagged = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'species': species,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'capturedAt': capturedAt.toIso8601String(),
        'imageUrl': imageUrl,
        'isFlagged': isFlagged,
      };

  factory TreeLocationModel.fromJson(Map<String, dynamic> json) => TreeLocationModel(
        id: json['id'],
        species: json['species'],
        position: LatLng(json['latitude'], json['longitude']),
        capturedAt: DateTime.parse(json['capturedAt']),
        imageUrl: json['imageUrl'],
        isFlagged: json['isFlagged'] ?? false,
      );
}
