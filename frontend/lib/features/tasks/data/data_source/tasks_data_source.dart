import 'package:frontend/features/tasks/index.dart';

/// Defines a contract/template for classes impelementing the [TasksDataSource].
abstract class TasksDataSource {
  Future<CreateTaskResponse> createTask(
    CreateTaskParam params,
  );

  Future<TaskGrindScoreResponse> getTaskGrindScore(String username);

  Future<TriggerTaskWorkflowResponse> triggerTaskWorkflow(String taskId);

  Future<GetWorkflowResponse> getWorkflowByTaskId(String taskId);

  Future<GetWorkflowStepsResponse> getWorkflowStepsByWorkflowId(
      String workflowId);

  Future<StartWorkflowResponse> startWorkflow({
    required String taskId,
    required String workflowId,
    required String stepId,
  });

  Future<GetTaskMessagesResponse> getTaskMessages(String taskId);

  Future<void> addTaskMessage({
    required String taskId,
    required Map<String, dynamic> message,
  });

  Future<void> updateTaskAssistMode({
    required String taskId,
    bool assistMode = false,
  });
}
