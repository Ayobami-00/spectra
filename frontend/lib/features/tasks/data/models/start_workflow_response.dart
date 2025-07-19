class StartWorkflowResponse {
  final String? status;
  final String? message;
  final bool hasError;

  const StartWorkflowResponse({
    this.status,
    this.message,
    this.hasError = false,
  });

  factory StartWorkflowResponse.fromJson(Map<String, dynamic> json) {
    return StartWorkflowResponse(
      status: json["status"] as String?,
      message: json["message"] as String?,
    );
  }

  factory StartWorkflowResponse.hasError(String errorMessage) =>
      StartWorkflowResponse(
        status: "failed",
        message: errorMessage,
        hasError: true,
      );
}
