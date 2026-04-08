import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/report_model.dart';
import '../repository/reports_repository.dart';

class ReportsState {
  final ReportModel? data;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    ReportModel? data,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ReportsViewModel extends StateNotifier<ReportsState> {
  final ReportsRepository _repository;

  ReportsViewModel(this._repository) : super(const ReportsState()) {
    loadReports();
  }

  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repository.getReportsData();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) => ReportsRepository());

final reportsViewModelProvider = StateNotifierProvider<ReportsViewModel, ReportsState>((ref) {
  final repository = ref.watch(reportsRepositoryProvider);
  return ReportsViewModel(repository);
});
