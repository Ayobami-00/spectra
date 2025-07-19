import 'task.dart';

class CreateTaskResponse {
  final String? status;

  final String? message;

  final bool hasError;

  final Task? task;

  const CreateTaskResponse({
    required this.status,
    required this.message,
    this.task,
    this.hasError = false,
  });

  factory CreateTaskResponse.fromJson(Map<String, dynamic> json) {
    return CreateTaskResponse(
      status: json["status"] as String?,
      message: json["message"] as String?,
      task: Task.fromJson(json),
    );
  }

  factory CreateTaskResponse.hasError(String errorMessage) =>
      CreateTaskResponse(
        status: "failed",
        message: errorMessage,
        hasError: true,
      );
}
