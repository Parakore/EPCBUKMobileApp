import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/valuation_result_model.dart';
import '../../../providers/providers.dart';

class ValuationDetailViewModel extends FamilyAsyncNotifier<ValuationResultModel, String> {
  @override
  FutureOr<ValuationResultModel> build(String arg) async {
    final repository = ref.watch(valuationRepositoryProvider);
    return repository.getValuationResult(arg);
  }

  Future<void> recalculate() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(valuationRepositoryProvider);
      return repository.getValuationResult(arg);
    });
  }
}
