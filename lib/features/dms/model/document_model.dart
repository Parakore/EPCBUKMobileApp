class AppDocument {
  final String id;
  final String name;
  final String category;
  final String date;
  final String status;
  final String size;

  AppDocument({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.status,
    required this.size,
  });

  factory AppDocument.fromJson(Map<String, dynamic> json) {
    return AppDocument(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      size: json['size'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'date': date,
      'status': status,
      'size': size,
    };
  }
}
