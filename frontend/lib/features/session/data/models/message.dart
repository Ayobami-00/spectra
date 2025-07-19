class Message {
  final String id;
  final String sessionId;
  final String content;
  final String role;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sessionId,
    required this.content,
    required this.role,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      content: json['content'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
