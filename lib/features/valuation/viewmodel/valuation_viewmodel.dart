import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/valuation_state.dart';
import '../repository/valuation_repository.dart';


class ValuationViewModel extends StateNotifier<ValuationState> {
  ValuationViewModel() : super(_initialState()) {
    calculate();
  }

  static ValuationState _initialState() {
    final defaultSpecies = ValuationRepository.speciesList.first;
    return ValuationState(
      species: defaultSpecies,
      gbh: 120,
      height: 18,
      age: 30,
      marketRate: defaultSpecies.marketRate,
      location: LocationFactor.forest,
      numTrees: 1,
    );
  }

  void updateSpecies(String id) {
    final species = ValuationRepository.speciesList.firstWhere((s) => s.id == id);
    state = state.copyWith(species: species, marketRate: species.marketRate);
    calculate();
  }

  void updateGBH(double val) {
    state = state.copyWith(gbh: val);
    calculate();
  }

  void updateHeight(double val) {
    state = state.copyWith(height: val);
    calculate();
  }

  void updateAge(double val) {
    state = state.copyWith(age: val);
    calculate();
  }

  void updateLocation(LocationFactor loc) {
    state = state.copyWith(location: loc);
    calculate();
  }

  void updateMarketRate(double val) {
    state = state.copyWith(marketRate: val);
    calculate();
  }

  void calculate() {
    // 📐 Volume = (GBH² / 4π) × Height
    // GBH in cm -> girth in m
    final girthM = state.gbh / 100;
    final volume = (math.pow(girthM, 2) / (4 * math.pi)) * state.height;

    // 💰 Timber Value = Volume × Market Rate
    final timberValue = volume * state.marketRate;

    // 🌿 Age Factor = 1 + (Age / 100)
    final ageFactor = 1 + (state.age / 100);

    // 🌿 Env Cost = Base Rate × Age Factor × Eco Factor × Location Factor
    final envCost = ValuationRepository.baseRate * 
                    ageFactor * 
                    state.species.ecoFactor * 
                    state.location.value;

    // 🌳 NPV = Base Rate × Age Factor × 2.0 × Location Factor
    final npv = ValuationRepository.baseRate * ageFactor * 2.0 * state.location.value;

    // 🌱 Afforestation = Timber Value × 0.30
    final afforestation = timberValue * 0.30;

    // 🏆 Total = (Timber + Env + NPV + Afforestation) × NumTrees
    final baseTotal = timberValue + envCost + npv + afforestation;
    final total = baseTotal * state.numTrees;

    state = state.copyWith(
      volume: volume,
      timberValue: timberValue,
      envCost: envCost,
      npv: npv,
      afforestation: afforestation,
      total: total,
    );
  }
}
