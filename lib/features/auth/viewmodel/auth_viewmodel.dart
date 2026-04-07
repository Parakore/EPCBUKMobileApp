import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_role.dart';
import '../../../core/services/storage_service.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool otpSent;
  final String? pendingUserId;
  final String? pendingRole;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.otpSent = false,
    this.pendingUserId,
    this.pendingRole,
  });

  /// Derive UserRole from the logged-in user's role string
  UserRole? get role {
    if (user != null) {
      return UserRoleExtension.fromString(user!.role);
    }
    if (pendingRole != null) {
      return UserRoleExtension.fromString(pendingRole!);
    }
    return null;
  }

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? otpSent,
    String? pendingUserId,
    String? pendingRole,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      otpSent: otpSent ?? this.otpSent,
      pendingUserId: pendingUserId ?? this.pendingUserId,
      pendingRole: pendingRole ?? this.pendingRole,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final StorageService _storage;

  AuthViewModel(this._repository, this._storage) : super(const AuthState()) {
    _init();
  }

  void _init() {
    final user = _storage.getUser();
    if (user != null) {
      state = state.copyWith(user: user);
    }
  }

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
        pendingRole: role,
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
      
      // PERSISTENCE: Save to storage
      await _storage.saveUser(user);
      
      state = state.copyWith(user: user, isLoading: false, otpSent: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void logout() async {
    await _storage.clearAll();
    state = const AuthState();
  }
}
