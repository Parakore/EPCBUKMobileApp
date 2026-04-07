import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/new_application_state.dart';

final newApplicationViewModelProvider =
    StateNotifierProvider.autoDispose<NewApplicationViewModel, NewApplicationState>((ref) {
  return NewApplicationViewModel();
});

class NewApplicationViewModel extends StateNotifier<NewApplicationState> {
  NewApplicationViewModel() : super(const NewApplicationState());

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // --- Applicant Detail Updates ---
  void updateApplicant(ApplicantDetails details) {
    state = state.copyWith(applicantDetails: details);
  }

  void updateApplicantField({
    String? type,
    String? fullName,
    String? aadhaar,
    String? mobile,
    String? email,
    String? purpose,
  }) {
    state = state.copyWith(
      applicantDetails: state.applicantDetails.copyWith(
        type: type,
        fullName: fullName,
        aadhaar: aadhaar,
        mobile: mobile,
        email: email,
        purpose: purpose,
      ),
    );
  }

  // --- Land Detail Updates ---
  void updateLand(LandDetails details) {
    state = state.copyWith(landDetails: details);
  }

  void updateLandField({
    String? district,
    String? block,
    String? village,
    String? khasra,
    String? landType,
    double? area,
    double? latitude,
    double? longitude,
  }) {
    state = state.copyWith(
      landDetails: state.landDetails.copyWith(
        district: district,
        block: block,
        village: village,
        khasra: khasra,
        landType: landType,
        area: area,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  // --- Tree Detail Updates ---
  void setTrees(List<TreeDetail> trees) {
    state = state.copyWith(trees: trees);
  }

  void addTree() {
    state = state.copyWith(trees: [...state.trees, const TreeDetail()]);
  }

  void removeTree(int index) {
    if (state.trees.length > 1) {
      final newTrees = List<TreeDetail>.from(state.trees);
      newTrees.removeAt(index);
      state = state.copyWith(trees: newTrees);
    }
  }

  void updateTree(int index, TreeDetail detail) {
    final newTrees = List<TreeDetail>.from(state.trees);
    newTrees[index] = detail;
    state = state.copyWith(trees: newTrees);
  }

  // --- Document Updates ---
  void updateDocument(String key, String? path) {
    final newDocs = Map<String, String?>.from(state.documents);
    newDocs[key] = path;
    state = state.copyWith(documents: newDocs);
  }

  // --- Simulation Actions ---
  Future<void> simulateGPSCapture() async {
    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(seconds: 1));
    updateLandField(latitude: 30.3165, longitude: 78.0322);
    state = state.copyWith(isSubmitting: false);
  }

  Future<void> simulateAadhaarVerify() async {
    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isSubmitting: false);
    // In real app, this might update a "isVerified" flag
  }

  Future<void> submitApplication() async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 2));
      // Success logic
      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }
}
