import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/compliance_model.dart';
import '../../../providers/providers.dart';

class ComplianceViewModel extends AsyncNotifier<List<ComplianceCase>> {
  @override
  Future<List<ComplianceCase>> build() async {
    return _fetchComplianceCases();
  }

  Future<List<ComplianceCase>> _fetchComplianceCases() async {
    return ref.read(complianceRepositoryProvider).getComplianceCases();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchComplianceCases());
  }
}

final complianceViewModelProvider = AsyncNotifierProvider<ComplianceViewModel, List<ComplianceCase>>(() {
  return ComplianceViewModel();
});
