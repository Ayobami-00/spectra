import 'session.dart';

class CreateSessionResponse {
  final String? status;

  final String? message;

  final bool hasError;

  final Session? session;

  const CreateSessionResponse({
    required this.status,
    required this.message,
    this.session,
    this.hasError = false,
  });

  factory CreateSessionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSessionResponse(
      status: json["status"] as String?,
      message: json["message"] as String?,
      session: Session.fromJson(json),
    );
  }

  factory CreateSessionResponse.hasError(String errorMessage) =>
      CreateSessionResponse(
        status: "failed",
        message: errorMessage,
        hasError: true,
      );
}
