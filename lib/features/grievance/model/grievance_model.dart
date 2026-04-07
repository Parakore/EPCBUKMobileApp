class Grievance {
  final String id;
  final String date;
  final String category;
  final String status;
  final String priority;
  final String subject;
  final String description;

  Grievance({
    required this.id,
    required this.date,
    required this.category,
    required this.status,
    required this.priority,
    required this.subject,
    required this.description,
  });

  factory Grievance.fromJson(Map<String, dynamic> json) {
    return Grievance(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'category': category,
      'status': status,
      'priority': priority,
      'subject': subject,
      'description': description,
    };
  }
}
