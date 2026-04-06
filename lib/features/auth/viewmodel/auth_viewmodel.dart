import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool otpSent;
  final String? pendingUserId;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.otpSent = false,
    this.pendingUserId,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? otpSent,
    String? pendingUserId,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      otpSent: otpSent ?? this.otpSent,
      pendingUserId: pendingUserId ?? this.pendingUserId,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(AuthState());

  Future<bool> sendOtp({
    required String role,
    required String userId,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.sendOtp(
        role: role,
        userId: userId,
        password: password,
      );
      state = state.copyWith(
        isLoading: false, 
        otpSent: true, 
        pendingUserId: userId,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (state.pendingUserId == null) {
      state = state.copyWith(error: 'Session expired. Please login again.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.verifyOtp(
        userId: state.pendingUserId!,
        otp: otp,
      );
      state = state.copyWith(user: user, isLoading: false, otpSent: false);
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
