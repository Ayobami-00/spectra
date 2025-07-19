import 'workflow.dart';

class GetWorkflowStepsResponse {
  final List<WorkflowStep>? steps;
  final String? message;
  final bool hasError;

  const GetWorkflowStepsResponse({
    this.steps,
    this.message,
    this.hasError = false,
  });

  factory GetWorkflowStepsResponse.hasError(String message) {
    return GetWorkflowStepsResponse(
      message: message,
      hasError: true,
    );
  }

  factory GetWorkflowStepsResponse.fromJson(List<Map<String, dynamic>> json) {
    return GetWorkflowStepsResponse(
      steps: (json).map((step) => WorkflowStep.fromJson(step)).toList(),
    );
  }

  factory GetWorkflowStepsResponse.empty() {
    return const GetWorkflowStepsResponse(
      steps: [],
    );
  }
}
