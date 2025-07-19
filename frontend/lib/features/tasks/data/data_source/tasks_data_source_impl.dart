// ignore_for_file: unused_field

import 'package:frontend/core/api/api_client/index.dart';
import 'package:frontend/features/tasks/index.dart';

class TasksDataSourceImpl implements TasksDataSource {
  static const _createTaskPath = '/tasks';
  final FeApiClient _apiClient;
  final String _baseApiUrl;
  final String _assistantApiUrl;
  final String _assistantApiKey;
  final String _assistantSuperadminApiEmail;
  final String _assistantSuperadminApiPassword;
  String? _assistantApiAccessToken;

  TasksDataSourceImpl(
    this._apiClient,
    this._baseApiUrl,
    this._assistantApiUrl,
    this._assistantApiKey,
    this._assistantSuperadminApiEmail,
    this._assistantSuperadminApiPassword,
  );

  Future<void> _ensureAuthenticated() async {
    if (_assistantApiAccessToken != null) return;

    try {
      final loginResponse = await _apiClient.post(
        '$_baseApiUrl/auth/login',
        data: {
          'email': _assistantSuperadminApiEmail,
          'password': _assistantSuperadminApiPassword,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );

      _assistantApiAccessToken = loginResponse.data['access_token'];
    } catch (e) {
      // If login fails, try to create the user
      final _ = await _apiClient.post(
        '$_baseApiUrl/users',
        data: {
          'email': _assistantSuperadminApiEmail,
          'password': _assistantSuperadminApiPassword,
          'username': _assistantSuperadminApiEmail,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Try logging in again after user creation
      final loginResponse = await _apiClient.post(
        '$_baseApiUrl/auth/login',
        data: {
          'email': _assistantSuperadminApiEmail,
          'password': _assistantSuperadminApiPassword,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );

      _assistantApiAccessToken = loginResponse.data['access_token'];
    }
  }

  @override
  Future<CreateTaskResponse> createTask(
    CreateTaskParam params,
  ) async {
    final response = await _apiClient.post(
      '$_baseApiUrl$_createTaskPath',
      data: params.toMap(),
    );

    return CreateTaskResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<TaskGrindScoreResponse> getTaskGrindScore(String username) async {
    final response = await _apiClient.get(
      '$_baseApiUrl/users/$username/tasks/grind-score',
    );

    return TaskGrindScoreResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<TriggerTaskWorkflowResponse> triggerTaskWorkflow(String taskId) async {
    await _ensureAuthenticated();
    final response = await _apiClient.post(
      '$_assistantApiUrl/v1/task/workflow/trigger',
      data: {
        "task_id": taskId,
      },
      headers: {
        "Content-Type": "application/json",
        "X-API-KEY": _assistantApiKey,
        "Authorization": "Bearer $_assistantApiAccessToken",
      },
    );

    return TriggerTaskWorkflowResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<GetWorkflowResponse> getWorkflowByTaskId(String taskId) async {
    await _ensureAuthenticated();
    final response = await _apiClient.get(
      '$_baseApiUrl/workflows/$taskId',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_assistantApiAccessToken',
      },
    );

    final List<dynamic> workflows = response.data as List;
    if (workflows.isEmpty) {
      return GetWorkflowResponse.empty();
    }

    // Explicitly cast the workflow data to Map<String, dynamic>
    final workflowData =
        Map<String, dynamic>.from(workflows[0] as Map<String, dynamic>);
    return GetWorkflowResponse.fromJson(workflowData);
  }

  @override
  Future<GetWorkflowStepsResponse> getWorkflowStepsByWorkflowId(
      String workflowId) async {
    await _ensureAuthenticated();
    final response = await _apiClient.get(
      '$_baseApiUrl/workflow_steps/$workflowId',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_assistantApiAccessToken',
      },
    );

    final List<dynamic> steps = response.data as List;
    if (steps.isEmpty) {
      return GetWorkflowStepsResponse.empty();
    }

    final workflowData =
        steps.map((step) => Map<String, dynamic>.from(step as Map)).toList();

    return GetWorkflowStepsResponse.fromJson(workflowData);
  }

  @override
  Future<StartWorkflowResponse> startWorkflow({
    required String taskId,
    required String workflowId,
    required String stepId,
  }) async {
    await _ensureAuthenticated();

    final response = await _apiClient.post(
      '$_assistantApiUrl/v1/task/workflow/start',
      data: {
        "task_id": taskId,
        "workflow_id": workflowId,
        "step_id": stepId,
      },
      headers: {
        "Content-Type": "application/json",
        "X-API-KEY": _assistantApiKey,
        "Authorization": "Bearer $_assistantApiAccessToken",
      },
    );

    return StartWorkflowResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<GetTaskMessagesResponse> getTaskMessages(String taskId) async {
    await _ensureAuthenticated();

    final response = await _apiClient.get(
      '$_assistantApiUrl/v1/message/$taskId/messages',
      headers: {
        'Content-Type': 'application/json',
        'X-API-KEY': _assistantApiKey,
        'Authorization': 'Bearer $_assistantApiAccessToken',
      },
    );

    // Wrap the response data in a map structure that matches GetTaskMessagesResponse
    final wrappedResponse = {
      'messages': response.data,
    };

    return GetTaskMessagesResponse.fromJson(wrappedResponse);
  }

  @override
  Future<void> addTaskMessage({
    required String taskId,
    required Map<String, dynamic> message,
  }) async {
    await _ensureAuthenticated();

    await _apiClient.post(
      '$_assistantApiUrl/v1/message/$taskId/messages',
      data: message,
      headers: {
        'Content-Type': 'application/json',
        'X-API-KEY': _assistantApiKey,
        'Authorization': 'Bearer $_assistantApiAccessToken',
      },
    );
  }

  @override
  Future<void> updateTaskAssistMode({
    required String taskId,
    bool assistMode = false,
  }) async {
    await _ensureAuthenticated();

    await _apiClient.post(
      '$_assistantApiUrl/v1/task/$taskId/assist',
      queryParameters: {
        'assist_mode': assistMode.toString(),
      },
      headers: {
        'Content-Type': 'application/json',
        'X-API-KEY': _assistantApiKey,
        'Authorization': 'Bearer $_assistantApiAccessToken',
      },
    );
  }
}
