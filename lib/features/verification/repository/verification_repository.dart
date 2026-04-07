import '../model/verification_model.dart';

abstract class VerificationRepository {
  Future<List<VerificationModel>> getPendingVerifications();
  Future<bool> verifyApplication(String id, bool approved);
}

class VerificationRepositoryImpl implements VerificationRepository {
  @override
  Future<List<VerificationModel>> getPendingVerifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(10, (index) => VerificationModel.mock(index));
  }

  @override
  Future<bool> verifyApplication(String id, bool approved) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
