import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/application_model.dart';
import '../../../core/widgets/app_badge.dart';

class ApplicationRepository {
  Future<List<ApplicationModel>> getApplications() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      ApplicationModel(
        id: 'TCA-2025-0862',
        applicant: 'Mohan Das',
        district: 'Dehradun',
        treeCount: 3,
        compensation: '₹98,000',
        stage: 'Submitted',
        stageClass: BadgeType.info,
        date: '29 Mar 25',
        sla: 'On Time',
        slaClass: BadgeType.success,
      ),
      ApplicationModel(
        id: 'TCA-2025-0851',
        applicant: 'NH-72 Proj (NHAI)',
        district: 'Haridwar',
        treeCount: 8,
        compensation: '₹3,24,000',
        stage: 'Verification',
        stageClass: BadgeType.warning,
        date: '25 Mar 25',
        sla: 'On Time',
        slaClass: BadgeType.success,
      ),
      ApplicationModel(
        id: 'TCA-2025-0847',
        applicant: 'Ramesh Kumar',
        district: 'Dehradun',
        treeCount: 4,
        compensation: '₹1,24,000',
        stage: 'Field Survey',
        stageClass: BadgeType.warning,
        date: '22 Mar 25',
        sla: 'At Risk',
        slaClass: BadgeType.warning,
      ),
      ApplicationModel(
        id: 'TCA-2025-0843',
        applicant: 'UJVNL Hydro Proj',
        district: 'Tehri',
        treeCount: 12,
        compensation: '₹5,84,000',
        stage: 'DM Approval',
        stageClass: BadgeType.gold,
        date: '18 Mar 25',
        sla: 'Breach',
        slaClass: BadgeType.danger,
      ),
      ApplicationModel(
        id: 'TCA-2025-0835',
        applicant: 'Haridwar Bypass',
        district: 'Haridwar',
        treeCount: 19,
        compensation: '₹8,12,000',
        stage: 'Treasury',
        stageClass: BadgeType.purple,
        date: '12 Mar 25',
        sla: 'On Time',
        slaClass: BadgeType.success,
      ),
      ApplicationModel(
        id: 'TCA-2025-0821',
        applicant: 'Nainital Resort',
        district: 'Nainital',
        treeCount: 6,
        compensation: '₹2,14,000',
        stage: 'Completed',
        stageClass: BadgeType.success,
        date: '5 Mar 25',
        sla: 'Done',
        slaClass: BadgeType.info,
      ),
    ];
  }
}

final applicationRepositoryProvider = Provider((ref) => ApplicationRepository());
