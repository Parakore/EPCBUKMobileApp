import '../model/compliance_model.dart';

class ComplianceRepository {
  Future<List<ComplianceCase>> getComplianceCases() async {
    // Mocking an API call
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ComplianceCase(
        id: 'TCA-2025-0843',
        project: 'UJVNL Hydro Project',
        district: 'Tehri',
        areaType: 'Forest Land',
        ecStatus: 'Required',
        status: 'Pending',
        risk: 'High',
      ),
      ComplianceCase(
        id: 'TCA-2025-0851',
        project: 'NH-72 Widening',
        district: 'Haridwar',
        areaType: 'Protected Zone',
        ecStatus: 'Granted',
        status: 'Compliant',
        risk: 'Medium',
      ),
      ComplianceCase(
        id: 'TCA-2025-0856',
        project: 'Mining Access Road',
        district: 'Almora',
        areaType: 'Reserve Forest',
        ecStatus: 'Required',
        status: 'Violation',
        risk: 'Very High',
      ),
    ];
  }
}
