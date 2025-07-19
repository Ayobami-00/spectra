class OtpVerificationResponse {
  final String? status;

  final String? message;

  final bool? hasError;

  const OtpVerificationResponse({
    required this.status,
    required this.message,
    this.hasError = false,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) =>
      OtpVerificationResponse(
        status: json['status'] as String?,
        message: json['message'] as String?,
      );

  factory OtpVerificationResponse.hasError(String errorMessage) =>
      OtpVerificationResponse(
        status: "failed",
        message: errorMessage,
        hasError: true,
      );
}
