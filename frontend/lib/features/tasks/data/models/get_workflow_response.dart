import 'workflow.dart';

class GetWorkflowResponse {
  final Workflow? workflow;
  final String? message;
  final bool hasError;

  const GetWorkflowResponse({
    this.workflow,
    this.message,
    this.hasError = false,
  });

  factory GetWorkflowResponse.hasError(String message) {
    return GetWorkflowResponse(
      message: message,
      hasError: true,
    );
  }

  factory GetWorkflowResponse.fromJson(Map<String, dynamic> json) {
    return GetWorkflowResponse(
      workflow: Workflow.fromJson(json),
    );
  }

  factory GetWorkflowResponse.empty() {
    return const GetWorkflowResponse(
      workflow: null,
      message: null,
      hasError: false,
    );
  }
}
