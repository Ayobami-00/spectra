class Task {
  final String id;
  final String title;
  final String description;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'] as String,
    );
  }
}
