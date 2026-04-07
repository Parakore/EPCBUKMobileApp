import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import '../repository/notification_repository.dart';

class NotificationNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const AsyncValue.loading()) {
    getNotifications();
  }

  Future<void> getNotifications() async {
    state = const AsyncValue.loading();
    try {
      final notifications = await _repository.getNotifications();
      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void markAsRead(String id) {
    state.whenData((notifications) {
      state = AsyncValue.data(
        notifications.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList(),
      );
    });
  }

  void markAllAsRead() {
    state.whenData((notifications) {
      state = AsyncValue.data(
        notifications.map((n) => n.copyWith(isRead: true)).toList(),
      );
    });
  }
}
