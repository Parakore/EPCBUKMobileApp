import 'package:epcbuk_mobile_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/application_model.dart';
import '../repository/application_repository.dart';

class ApplicationsState {
  final List<ApplicationModel> applications;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  ApplicationsState({
    required this.applications,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  ApplicationsState copyWith({
    List<ApplicationModel>? applications,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return ApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ApplicationsViewModel extends StateNotifier<ApplicationsState> {
  final ApplicationRepository _repository;

  ApplicationsViewModel(this._repository)
      : super(ApplicationsState(applications: [])) {
    loadApplications();
  }

  Future<void> loadApplications() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final apps = await _repository.getApplications();
      state = state.copyWith(applications: apps, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<ApplicationModel> get filteredApplications {
    if (state.searchQuery.isEmpty) return state.applications;
    return state.applications.where((app) {
      return app.id.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
          app.applicant.toLowerCase().contains(state.searchQuery.toLowerCase());
    }).toList();
  }
}

final applicationsViewModelProvider =
    StateNotifierProvider<ApplicationsViewModel, ApplicationsState>((ref) {
  return ApplicationsViewModel(ref.watch(applicationRepositoryProvider));
});
