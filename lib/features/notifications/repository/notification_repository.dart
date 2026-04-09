import 'package:dio/dio.dart';
import '../model/notification_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

class NotificationRepository {
  final Dio dio;

  NotificationRepository(this.dio);

  Future<List<NotificationModel>> getNotifications() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockNotifications;
    }

    try {
      final response = await dio.get(ApiEndpoints.notifications);
      final List<dynamic> data = response.data;
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  static List<NotificationModel> get _mockNotifications => [
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
          description: 'Pollution Control Board requires document verification.',
          timeAgo: '1 hr ago',
          type: NotificationType.compliance,
        ),
      ];
}
