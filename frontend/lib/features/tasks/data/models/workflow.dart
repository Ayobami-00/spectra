class Workflow {
  final String id;
  final String taskId;
  final String createdBy;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Workflow({
    required this.id,
    required this.taskId,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      id: json['id']?.toString() ?? '',
      taskId: json['task_id']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
    );
  }
}

class WorkflowStep {
  final String id;
  final String workflowId;
  final String usecaseId;
  final String usecaseType;
  final int stepOrder;
  final String description;
  final String status;
  final String assignedAgent;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkflowStep({
    required this.id,
    required this.workflowId,
    required this.usecaseId,
    required this.usecaseType,
    required this.stepOrder,
    required this.description,
    required this.status,
    required this.assignedAgent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkflowStep.fromJson(Map<String, dynamic> json) {
    return WorkflowStep(
      id: json['id'] as String,
      workflowId: json['workflow_id'] as String,
      usecaseId: json['usecase_id'] as String,
      usecaseType: json['usecase_type'] as String,
      stepOrder: json['step_order'] as int,
      description: json['step_description'] as String,
      status: json['status'] as String,
      assignedAgent: json['assigned_agent'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
