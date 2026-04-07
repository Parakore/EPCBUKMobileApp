enum NotificationType {
  submission,
  sla,
  compliance,
  payment,
  approval,
  survey,
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? timeAgo,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeAgo: timeAgo ?? this.timeAgo,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
