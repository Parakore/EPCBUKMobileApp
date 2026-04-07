import '../model/grievance_model.dart';

class GrievanceRepository {
  Future<List<Grievance>> getGrievances() async {
    // Mocking an API call
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Grievance(
        id: 'GRV-084',
        date: '22 Mar 2025',
        category: 'Application Delay',
        status: 'Open',
        priority: 'High',
        subject: 'Delay in site inspection',
        description: 'Forest guard has not visited the plot since 2 weeks.',
      ),
      Grievance(
        id: 'GRV-082',
        date: '18 Mar 2025',
        category: 'Payment Issue',
        status: 'Resolved',
        priority: 'Medium',
        subject: 'Double payment debited',
        description: 'Payment of ₹1,24,000 debited twice from my bank. Refunded.',
      ),
      Grievance(
        id: 'GRV-078',
        date: '10 Mar 2025',
        category: 'Technical Bug',
        status: 'Resolved',
        priority: 'Low',
        subject: 'Unable to upload PDF',
        description: 'Fixed by clearance of cache.',
      ),
      Grievance(
        id: 'GRV-086',
        date: '25 Mar 2025',
        category: 'Incorrect Tree Count',
        status: 'Open',
        priority: 'High',
        subject: 'Species mismatch',
        description: 'Report says 4 Sal trees, but I have 6.',
      ),
    ];
  }
}
