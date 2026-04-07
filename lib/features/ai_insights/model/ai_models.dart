import 'package:flutter/foundation.dart';

@immutable
class AIAnalysisModel {
  final String id;
  final String species;
  final double confidence;
  final DateTime predictionTime;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const AIAnalysisModel({
    required this.id,
    required this.species,
    required this.confidence,
    required this.predictionTime,
    this.imageUrl,
    this.metadata,
  });

  factory AIAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AIAnalysisModel(
      id: json['id'] as String,
      species: json['species'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      predictionTime: DateTime.parse(json['predictionTime'] as String),
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species': species,
      'confidence': confidence,
      'predictionTime': predictionTime.toIso8601String(),
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }
}

enum RiskLevel { low, medium, high, veryHigh }

@immutable
class ScatterPointModel {
  final double x; // Predicted value
  final double y; // Actual value

  const ScatterPointModel({required this.x, required this.y});

  factory ScatterPointModel.fromJson(Map<String, dynamic> json) {
    return ScatterPointModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }
}

@immutable
class FraudAlertModel {
  final String id;
  final String applicationId;
  final RiskLevel riskLevel;
  final String reason;
  final DateTime timestamp;
  final bool isResolved;

  const FraudAlertModel({
    required this.id,
    required this.applicationId,
    required this.riskLevel,
    required this.reason,
    required this.timestamp,
    this.isResolved = false,
  });

  factory FraudAlertModel.fromJson(Map<String, dynamic> json) {
    return FraudAlertModel(
      id: json['id'] as String,
      applicationId: json['applicationId'] as String,
      riskLevel: RiskLevel.values.byName(json['riskLevel'] as String),
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isResolved: json['isResolved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicationId': applicationId,
      'riskLevel': riskLevel.name,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
      'isResolved': isResolved,
    };
  }
}
