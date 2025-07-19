class GetTaskMessagesResponse {
  final List<TaskMessage> messages;
  final String? message;
  final bool hasError;

  const GetTaskMessagesResponse({
    this.messages = const [],
    this.message,
    this.hasError = false,
  });

  factory GetTaskMessagesResponse.fromJson(Map<String, dynamic> json) {
    final messagesList = json['messages'] as List<dynamic>?;
    return GetTaskMessagesResponse(
      messages: messagesList
              ?.where((m) => (m['type'] as String) != 'action')
              .map((m) => TaskMessage.fromJson(m))
              .toList() ??
          [],
    );
  }

  factory GetTaskMessagesResponse.hasError(String errorMessage) =>
      GetTaskMessagesResponse(
        message: errorMessage,
        hasError: true,
      );
}

class TaskMessage {
  final String content;
  final String role;
  final DateTime timestamp;
  final String type;

  const TaskMessage({
    required this.content,
    required this.role,
    required this.timestamp,
    required this.type,
  });

  factory TaskMessage.fromJson(Map<String, dynamic> json) {
    return TaskMessage(
      content: json['content'] as String,
      role: json['role'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
    );
  }
}
