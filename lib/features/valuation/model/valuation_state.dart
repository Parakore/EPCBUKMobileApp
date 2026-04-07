import 'tree_species.dart';

enum LocationFactor {
  normal(1.0, 'Normal Area'),
  forest(1.3, 'Forest Area'),
  sensitive(1.5, 'Eco-Sensitive Area');

  final double value;
  final String label;
  const LocationFactor(this.value, this.label);
}

class ValuationState {
  final TreeSpecies species;
  final double gbh; // in cm
  final double height; // in m
  final double age; // in years
  final double marketRate; // override from species
  final LocationFactor location;
  final int numTrees;

  // Calculated Results
  final double volume;
  final double timberValue;
  final double envCost;
  final double npv;
  final double afforestation;
  final double total;

  const ValuationState({
    required this.species,
    required this.gbh,
    required this.height,
    required this.age,
    required this.marketRate,
    required this.location,
    required this.numTrees,
    this.volume = 0,
    this.timberValue = 0,
    this.envCost = 0,
    this.npv = 0,
    this.afforestation = 0,
    this.total = 0,
  });

  ValuationState copyWith({
    TreeSpecies? species,
    double? gbh,
    double? height,
    double? age,
    double? marketRate,
    LocationFactor? location,
    int? numTrees,
    double? volume,
    double? timberValue,
    double? envCost,
    double? npv,
    double? afforestation,
    double? total,
  }) {
    return ValuationState(
      species: species ?? this.species,
      gbh: gbh ?? this.gbh,
      height: height ?? this.height,
      age: age ?? this.age,
      marketRate: marketRate ?? this.marketRate,
      location: location ?? this.location,
      numTrees: numTrees ?? this.numTrees,
      volume: volume ?? this.volume,
      timberValue: timberValue ?? this.timberValue,
      envCost: envCost ?? this.envCost,
      npv: npv ?? this.npv,
      afforestation: afforestation ?? this.afforestation,
      total: total ?? this.total,
    );
  }
}
