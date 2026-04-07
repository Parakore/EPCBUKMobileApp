import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/compliance_model.dart';
import '../repository/compliance_repository.dart';

final complianceRepositoryProvider = Provider<ComplianceRepository>((ref) {
  return ComplianceRepository();
});

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
