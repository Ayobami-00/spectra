class Session {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastMessageAt;
  final bool isArchived;
  final bool isPublic;

  Session({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessageAt,
    required this.isArchived,
    required this.isPublic,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastMessageAt: DateTime.parse(json['last_message_at']),
      isArchived: json['is_archived'] as bool,
      isPublic: json['is_public'] as bool,
    );
  }
}
