// ignore_for_file: unused_field

import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class TasksRepoImpl extends TasksRepo {
  final TasksDataSource _tasksDataSource;
  TasksRepoImpl(
    this._tasksDataSource,
  );

  @override
  Future<ApiResult<CreateTaskResponse>> createTask(
    CreateTaskParam params,
  ) {
    return apiInterceptor(
      _tasksDataSource.createTask(params),
    );
  }

  @override
  Future<ApiResult<TaskGrindScoreResponse>> getTaskGrindScore(String username) {
    return apiInterceptor(
      _tasksDataSource.getTaskGrindScore(username),
    );
  }

  @override
  Future<ApiResult<TriggerTaskWorkflowResponse>> triggerTaskWorkflow(
      String taskId) {
    return apiInterceptor(
      _tasksDataSource.triggerTaskWorkflow(taskId),
    );
  }

  @override
  Future<ApiResult<GetWorkflowResponse>> getWorkflowByTaskId(String taskId) {
    return apiInterceptor(
      _tasksDataSource.getWorkflowByTaskId(taskId),
    );
  }

  @override
  Future<ApiResult<GetWorkflowStepsResponse>> getWorkflowStepsByWorkflowId(
      String workflowId) {
    return apiInterceptor(
      _tasksDataSource.getWorkflowStepsByWorkflowId(workflowId),
    );
  }

  @override
  Future<ApiResult<StartWorkflowResponse>> startWorkflow({
    required String taskId,
    required String workflowId,
    required String stepId,
  }) {
    return apiInterceptor(
      _tasksDataSource.startWorkflow(
        taskId: taskId,
        workflowId: workflowId,
        stepId: stepId,
      ),
    );
  }

  @override
  Future<ApiResult<GetTaskMessagesResponse>> getTaskMessages(String taskId) {
    return apiInterceptor(
      _tasksDataSource.getTaskMessages(taskId),
    );
  }

  @override
  Future<ApiResult<void>> addTaskMessage({
    required String taskId,
    required Map<String, dynamic> message,
  }) {
    return apiInterceptor(
      _tasksDataSource.addTaskMessage(
        taskId: taskId,
        message: message,
      ),
    );
  }

  @override
  Future<ApiResult<void>> updateTaskAssistMode({
    required String taskId,
    bool assistMode = false,
  }) {
    return apiInterceptor(
      _tasksDataSource.updateTaskAssistMode(
        taskId: taskId,
        assistMode: assistMode,
      ),
    );
  }
}
