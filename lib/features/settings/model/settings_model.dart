class SettingsModel {
  final int slaGuard;
  final int slaRO;
  final int slaDFO;
  final int slaDM;
  final int slaTreasury;
  
  final bool enableSMS;
  final bool enableEmail;
  final bool enableWhatsApp;
  final bool enableSLABreachAlert;

  const SettingsModel({
    this.slaGuard = 3,
    this.slaRO = 5,
    this.slaDFO = 7,
    this.slaDM = 10,
    this.slaTreasury = 2,
    this.enableSMS = true,
    this.enableEmail = true,
    this.enableWhatsApp = false,
    this.enableSLABreachAlert = true,
  });

  SettingsModel copyWith({
    int? slaGuard,
    int? slaRO,
    int? slaDFO,
    int? slaDM,
    int? slaTreasury,
    bool? enableSMS,
    bool? enableEmail,
    bool? enableWhatsApp,
    bool? enableSLABreachAlert,
  }) {
    return SettingsModel(
      slaGuard: slaGuard ?? this.slaGuard,
      slaRO: slaRO ?? this.slaRO,
      slaDFO: slaDFO ?? this.slaDFO,
      slaDM: slaDM ?? this.slaDM,
      slaTreasury: slaTreasury ?? this.slaTreasury,
      enableSMS: enableSMS ?? this.enableSMS,
      enableEmail: enableEmail ?? this.enableEmail,
      enableWhatsApp: enableWhatsApp ?? this.enableWhatsApp,
      enableSLABreachAlert: enableSLABreachAlert ?? this.enableSLABreachAlert,
    );
  }
}
