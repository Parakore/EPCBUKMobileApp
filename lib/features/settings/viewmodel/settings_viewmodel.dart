import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/settings_model.dart';

class SettingsViewModel extends StateNotifier<SettingsModel> {
  SettingsViewModel() : super(const SettingsModel());

  void setSlaGuard(String value) => state = state.copyWith(slaGuard: int.tryParse(value) ?? state.slaGuard);
  void setSlaRO(String value) => state = state.copyWith(slaRO: int.tryParse(value) ?? state.slaRO);
  void setSlaDFO(String value) => state = state.copyWith(slaDFO: int.tryParse(value) ?? state.slaDFO);
  void setSlaDM(String value) => state = state.copyWith(slaDM: int.tryParse(value) ?? state.slaDM);
  void setSlaTreasury(String value) => state = state.copyWith(slaTreasury: int.tryParse(value) ?? state.slaTreasury);

  void toggleSMS(bool value) => state = state.copyWith(enableSMS: value);
  void toggleEmail(bool value) => state = state.copyWith(enableEmail: value);
  void toggleWhatsApp(bool value) => state = state.copyWith(enableWhatsApp: value);
  void toggleSLABreachAlert(bool value) => state = state.copyWith(enableSLABreachAlert: value);

  void saveSettings() {
    // Logic to save settings via repository (mock for now)
    print('Settings Saved: ${state.toString()}');
  }
}

final settingsViewModelProvider = StateNotifierProvider<SettingsViewModel, SettingsModel>((ref) {
  return SettingsViewModel();
});
