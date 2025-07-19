class EmailVerificationResponse {
  final String? status;

  final String? message;

  final bool? hasError;

  const EmailVerificationResponse({
    required this.status,
    required this.message,
    this.hasError = false,
  });

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) =>
      EmailVerificationResponse(
        status: json['status'] as String?,
        message: json['name'] as String?,
      );

  factory EmailVerificationResponse.hasError() =>
      const EmailVerificationResponse(
        status: "credits_expired",
        message: "",
        hasError: true,
      );
}
