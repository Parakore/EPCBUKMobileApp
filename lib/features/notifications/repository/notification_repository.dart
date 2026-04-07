import '../model/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications() async {
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      NotificationModel(
        id: '1',
        title: 'Application #TCA-2025-0847 submitted',
        description: 'New tree cutting application has been successfully filed.',
        timeAgo: '2 min ago',
        type: NotificationType.submission,
      ),
      NotificationModel(
        id: '2',
        title: 'SLA breach: Case TCA-2025-0721 overdue by 3 days',
        description: 'Immediate action required for pending valuation.',
        timeAgo: '15 min ago',
        type: NotificationType.sla,
      ),
      NotificationModel(
        id: '3',
        title: 'UKPCB compliance check required for Tehri project',
        description: 'Uttarakhand Pollution Control Board requires document verification.',
        timeAgo: '1 hr ago',
        type: NotificationType.compliance,
      ),
      NotificationModel(
        id: '4',
        title: 'Payment of ₹4,82,000 confirmed for TCA-2025-0635',
        description: 'Treasury disbursement completed for NPV compensation.',
        timeAgo: '3 hr ago',
        type: NotificationType.payment,
      ),
      NotificationModel(
        id: '5',
        title: 'DFO approved 5 valuation reports',
        description: 'District Forest Officer has cleared the reports for Garhwal range.',
        timeAgo: '5 hr ago',
        type: NotificationType.approval,
      ),
      NotificationModel(
        id: '6',
        title: 'New tree survey completed at Haridwar Range',
        description: 'Field officer has uploaded enumeration data for 156 trees.',
        timeAgo: 'Yesterday',
        type: NotificationType.survey,
      ),
      NotificationModel(
        id: '7',
        title: 'District Magistrate final approval: TCA-2025-0712',
        description: 'Final clearance granted by DM Office for the Kumaon connectivity project.',
        timeAgo: 'Yesterday',
        type: NotificationType.approval,
      ),
    ];
  }
}
