class TriggerTaskWorkflowResponse {
  final String? status;
  final String? message;
  final bool hasError;
  final String? workflowId;

  const TriggerTaskWorkflowResponse({
    this.status,
    this.message,
    this.workflowId,
    this.hasError = false,
  });

  factory TriggerTaskWorkflowResponse.fromJson(Map<String, dynamic> json) {
    return TriggerTaskWorkflowResponse(
      status: json["status"] as String?,
      message: json["message"] as String?,
      workflowId: json["workflow_id"] as String?,
    );
  }

  factory TriggerTaskWorkflowResponse.hasError(String errorMessage) =>
      TriggerTaskWorkflowResponse(
        status: "failed",
        message: errorMessage,
        hasError: true,
      );
}
