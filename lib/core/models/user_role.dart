enum UserRole {
  applicant,
  forestGuard,
  rangeOfficer,
  dfo,
  ukpcb,
  dm,
  treasury,
  admin,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.applicant:
        return 'Citizen / Applicant';
      case UserRole.forestGuard:
        return 'Forest Guard';
      case UserRole.rangeOfficer:
        return 'Range Officer';
      case UserRole.dfo:
        return 'Divisional Forest Officer';
      case UserRole.ukpcb:
        return 'UKPCB Officer';
      case UserRole.dm:
        return 'District Magistrate';
      case UserRole.treasury:
        return 'Treasury Officer';
      case UserRole.admin:
        return 'State Admin';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.applicant:
        return 'Ramesh Kumar';
      case UserRole.forestGuard:
        return 'Suresh Rawat';
      case UserRole.rangeOfficer:
        return 'Dinesh Negi';
      case UserRole.dfo:
        return 'Rajiv Sharma';
      case UserRole.ukpcb:
        return 'Priya Bisht';
      case UserRole.dm:
        return 'Anand Verma, IAS';
      case UserRole.treasury:
        return 'Mohan Lal';
      case UserRole.admin:
        return 'State Admin User';
    }
  }

  /// Converts a raw string (from login) to UserRole
  static UserRole fromString(String value) {
    switch (value.toLowerCase().trim()) {
      case 'citizen / project proponent':
      case 'applicant':
        return UserRole.applicant;
      case 'forest guard':
      case 'forestguard':
        return UserRole.forestGuard;
      case 'range officer':
      case 'rangeofficer':
        return UserRole.rangeOfficer;
      case 'divisional forest officer (dfo)':
      case 'dfo':
        return UserRole.dfo;
      case 'ukpcb officer':
      case 'ukpcb':
        return UserRole.ukpcb;
      case 'district magistrate':
      case 'dm':
        return UserRole.dm;
      case 'treasury officer':
      case 'treasury':
        return UserRole.treasury;
      case 'state admin / command center':
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.applicant;
    }
  }
}
