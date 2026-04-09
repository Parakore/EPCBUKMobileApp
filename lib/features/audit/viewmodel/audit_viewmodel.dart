import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/audit_model.dart';
import '../repository/audit_repository.dart';

class AuditState {
  final List<AuditModel> logs;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const AuditState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  List<AuditModel> get filteredLogs {
    if (searchQuery.isEmpty) return logs;
    return logs
        .where((l) =>
            l.user.toLowerCase().contains(searchQuery.toLowerCase()) ||
            l.action.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (l.caseId?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false))
        .toList();
  }

  AuditState copyWith({
    List<AuditModel>? logs,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return AuditState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AuditViewModel extends StateNotifier<AuditState> {
  final AuditRepository _repository;

  AuditViewModel(this._repository) : super(const AuditState()) {
    loadLogs();
  }

  Future<void> loadLogs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final logs = await _repository.getAuditLogs();
      state = state.copyWith(logs: logs, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
