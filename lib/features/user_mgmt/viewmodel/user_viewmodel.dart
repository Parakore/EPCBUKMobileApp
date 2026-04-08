import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_mgmt_model.dart';
import '../repository/user_repository.dart';

class UserMgmtState {
  final List<UserMgmtModel> users;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const UserMgmtState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  List<UserMgmtModel> get filteredUsers {
    if (searchQuery.isEmpty) return users;
    return users
        .where((u) =>
            u.user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            u.user.role.toLowerCase().contains(searchQuery.toLowerCase()) ||
            u.district.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  UserMgmtState copyWith({
    List<UserMgmtModel>? users,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return UserMgmtState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class UserViewModel extends StateNotifier<UserMgmtState> {
  final UserRepository _repository;

  UserViewModel(this._repository) : super(const UserMgmtState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final users = await _repository.getUsers();
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

final userViewModelProvider = StateNotifierProvider<UserViewModel, UserMgmtState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserViewModel(repository);
});
