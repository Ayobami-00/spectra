import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

/// Defines a contract/template for classes impelementing the [TasksRepo].
abstract class TasksRepo {
  Future<ApiResult<CreateTaskResponse>> createTask(
    CreateTaskParam params,
  );

  Future<ApiResult<TaskGrindScoreResponse>> getTaskGrindScore(String username);

  Future<ApiResult<TriggerTaskWorkflowResponse>> triggerTaskWorkflow(
      String taskId);

  Future<ApiResult<GetWorkflowResponse>> getWorkflowByTaskId(String taskId);
  Future<ApiResult<GetWorkflowStepsResponse>> getWorkflowStepsByWorkflowId(
      String workflowId);

  Future<ApiResult<StartWorkflowResponse>> startWorkflow({
    required String taskId,
    required String workflowId,
    required String stepId,
  });

  Future<ApiResult<GetTaskMessagesResponse>> getTaskMessages(String taskId);

  Future<ApiResult<void>> addTaskMessage({
    required String taskId,
    required Map<String, dynamic> message,
  });

  Future<ApiResult<void>> updateTaskAssistMode({
    required String taskId,
    bool assistMode = false,
  });
}
