import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/grievance_model.dart';
import '../repository/grievance_repository.dart';

final grievanceRepositoryProvider = Provider<GrievanceRepository>((ref) {
  return GrievanceRepository();
});

class GrievanceViewModel extends AsyncNotifier<List<Grievance>> {
  @override
  Future<List<Grievance>> build() async {
    return _fetchGrievances();
  }

  Future<List<Grievance>> _fetchGrievances() async {
    return ref.read(grievanceRepositoryProvider).getGrievances();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchGrievances());
  }
}

final grievanceViewModelProvider = AsyncNotifierProvider<GrievanceViewModel, List<Grievance>>(() {
  return GrievanceViewModel();
});
