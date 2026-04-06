import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(AuthState());

  Future<bool> login({
    required String role,
    required String userId,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.login(
        role: role,
        userId: userId,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void logout() {
    state = AuthState();
  }
}
