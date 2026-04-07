import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/verification_model.dart';
import '../repository/verification_repository.dart';
import '../../../providers/providers.dart';

class VerificationViewModel extends AsyncNotifier<List<VerificationModel>> {
  late final VerificationRepository _repository;

  @override
  Future<List<VerificationModel>> build() async {
    _repository = ref.watch(verificationRepositoryProvider);
    return _repository.getPendingVerifications();
  }

  Future<void> performVerification(String id, bool approved) async {
    final success = await _repository.verifyApplication(id, approved);
    if (success) {
      // Refresh list locally by removing the verified item
      final currentList = state.value ?? [];
      state = AsyncValue.data(currentList.where((item) => item.id != id).toList());
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getPendingVerifications());
  }
}
