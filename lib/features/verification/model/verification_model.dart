enum VerificationStatus { pending, verified, rejected }

class VerificationModel {
  final String id;
  final String applicantName;
  final String projectType;
  final DateTime submittedAt;
  final VerificationStatus status;
  final String? location;

  VerificationModel({
    required this.id,
    required this.applicantName,
    required this.projectType,
    required this.submittedAt,
    this.status = VerificationStatus.pending,
    this.location,
  });

  factory VerificationModel.mock(int index) {
    final types = ['Residential Construction', 'Power Line Diversion', 'Bridge Project', 'Eco-Tourism Layout'];
    return VerificationModel(
      id: 'APP-${1000 + index}',
      applicantName: 'Applicant $index',
      projectType: types[index % types.length],
      submittedAt: DateTime.now().subtract(Duration(days: index)),
      status: VerificationStatus.pending,
      location: 'Dehradun, District ${index + 1}',
    );
  }
}
