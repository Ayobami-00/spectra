class CreateMessageParams {
  final String sessionId;
  final String content;
  final String role;

  CreateMessageParams({
    required this.sessionId,
    required this.content,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'role': role,
    };
  }
}
