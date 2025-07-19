import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../authentication/presentation/listeners/index.dart';

part '../../../tasks/presentation/logic/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> implements OnAppStartLazy {
  final CreateTask createTask;
  final GetTaskGrindScore getTaskGrindScore;
  final TriggerTaskWorkflow triggerTaskWorkflow;
  final GetWorkflowByTaskId getWorkflowByTaskId;
  final GetWorkflowSteps getWorkflowSteps;
  final StartWorkflow startWorkflow;
  final GetTaskMessages getTaskMessages;
  final AddTaskMessage addTaskMessage;
  final UpdateTaskAssistMode updateTaskAssistMode;

  Task? task;
  TaskGrindScoreResponse? grindScore;
  Workflow? currentWorkflow;
  List<WorkflowStep>? currentWorkflowSteps;
  List<TaskMessage>? currentTaskMessages;

  TasksCubit(
    this.createTask,
    this.getTaskGrindScore,
    this.triggerTaskWorkflow,
    this.getWorkflowByTaskId,
    this.getWorkflowSteps,
    this.startWorkflow,
    this.getTaskMessages,
    this.addTaskMessage,
    this.updateTaskAssistMode,
  ) : super(TasksInitial());

  Future<CreateTaskResponse> createTaskLogic(String description) async {
    final _ = CreateTaskParam(
      description: description,
      dueAt: DateTime.now().add(const Duration(days: 5)),
    );
    final response = await createTask(_);
    return response.maybeWhen(
      success: (data) {
        task = data.task;
        return data;
      },
      apiFailure: (exception, _) => CreateTaskResponse.hasError(
        ApiExceptions.getErrorMessage(exception),
      ),
      orElse: () => CreateTaskResponse.hasError(
        AppConstants.defaultErrorMessage,
      ),
    );
  }

  Future<TaskGrindScoreResponse> getGrindScore(String username) async {
    emit(TasksLoading());
    final response = await getTaskGrindScore(username);
    return response.maybeWhen(
      success: (data) {
        grindScore = data;
        emit(TasksLoaded(data: data));
        return data;
      },
      apiFailure: (exception, _) {
        final error = TaskGrindScoreResponse.hasError(
          ApiExceptions.getErrorMessage(exception),
        );
        emit(TasksError(error.message!));
        return error;
      },
      orElse: () {
        final error = TaskGrindScoreResponse.hasError(
          AppConstants.defaultErrorMessage,
        );
        emit(TasksError(error.message!));
        return error;
      },
    );
  }

  Future<TriggerTaskWorkflowResponse> triggerTaskWorkflowLogic(
      String taskId) async {
    emit(TasksLoading());

    final result = await triggerTaskWorkflow(taskId);

    return result.maybeWhen(
      success: (response) {
        if (!response.hasError) {
          emit(TasksLoaded(data: response));
          return response;
        } else {
          emit(TasksError(response.message ?? "Failed to trigger workflow"));
          return response;
        }
      },
      apiFailure: (error, _) {
        final response = TriggerTaskWorkflowResponse.hasError(
          ApiExceptions.getErrorMessage(error),
        );
        emit(TasksError(response.message!));
        return response;
      },
      orElse: () {
        final response = TriggerTaskWorkflowResponse.hasError(
          AppConstants.defaultErrorMessage,
        );
        emit(const TasksError(AppConstants.defaultErrorMessage));
        return response;
      },
    );
  }

  Future<GetWorkflowResponse> fetchWorkflowByTaskIdLogic(String taskId) async {
    emit(TasksLoading());

    final result = await getWorkflowByTaskId(taskId);

    return result.maybeWhen(
      success: (workflow) {
        currentWorkflow = workflow.workflow;
        emit(TasksLoaded(data: workflow.workflow));
        return workflow;
      },
      apiFailure: (error, _) {
        final response = GetWorkflowResponse.hasError(
          ApiExceptions.getErrorMessage(error),
        );
        emit(TasksError(response.message!));
        return response;
      },
      orElse: () {
        final response = GetWorkflowResponse.hasError(
          AppConstants.defaultErrorMessage,
        );
        emit(const TasksError(AppConstants.defaultErrorMessage));
        return response;
      },
    );
  }

  Future<GetWorkflowStepsResponse> fetchWorkflowStepsLogic(
      String workflowId) async {
    emit(TasksLoading());

    final result = await getWorkflowSteps(workflowId);

    return result.maybeWhen(
      success: (steps) {
        currentWorkflowSteps = steps.steps;
        emit(TasksLoaded(data: steps.steps));
        return steps;
      },
      apiFailure: (error, _) {
        final response = GetWorkflowStepsResponse.hasError(
          ApiExceptions.getErrorMessage(error),
        );
        emit(TasksError(response.message!));
        return response;
      },
      orElse: () {
        final response = GetWorkflowStepsResponse.hasError(
          AppConstants.defaultErrorMessage,
        );
        emit(const TasksError(AppConstants.defaultErrorMessage));
        return response;
      },
    );
  }

  Future<StartWorkflowResponse> startWorkflowLogic({
    required String taskId,
    required String workflowId,
    required String stepId,
  }) async {
    emit(TasksLoading());

    final result = await startWorkflow(StartWorkflowParams(
      taskId: taskId,
      workflowId: workflowId,
      stepId: stepId,
    ));

    return result.maybeWhen(
      success: (response) {
        if (!response.hasError) {
          emit(TasksLoaded(data: response));
          return response;
        } else {
          emit(TasksError(response.message ?? "Failed to start workflow"));
          return response;
        }
      },
      apiFailure: (error, _) {
        final response = StartWorkflowResponse.hasError(
          ApiExceptions.getErrorMessage(error),
        );
        emit(TasksError(response.message!));
        return response;
      },
      orElse: () {
        final response = StartWorkflowResponse.hasError(
          AppConstants.defaultErrorMessage,
        );
        emit(const TasksError(AppConstants.defaultErrorMessage));
        return response;
      },
    );
  }

  Future<GetTaskMessagesResponse> fetchTaskMessagesLogic(String taskId) async {
    emit(TasksLoading());

    final result = await getTaskMessages(taskId);

    return result.maybeWhen(
      success: (response) {
        currentTaskMessages = response.messages;
        emit(TasksLoaded(data: response.messages));
        return response;
      },
      apiFailure: (error, _) {
        final response = GetTaskMessagesResponse.hasError(
          ApiExceptions.getErrorMessage(error),
        );
        emit(TasksError(response.message!));
        return response;
      },
      orElse: () {
        final response = GetTaskMessagesResponse.hasError(
          AppConstants.defaultErrorMessage,
        );
        emit(const TasksError(AppConstants.defaultErrorMessage));
        return response;
      },
    );
  }

  Future<void> addTaskMessageLogic({
    required String taskId,
    required Map<String, dynamic> message,
  }) async {
    emit(TasksLoading());

    final result = await addTaskMessage(AddTaskMessageParams(
      taskId: taskId,
      message: message,
    ));

    result.maybeWhen(
      success: (_) {
        emit(TasksLoaded(data: null));
      },
      apiFailure: (error, _) {
        emit(TasksError(ApiExceptions.getErrorMessage(error)));
      },
      orElse: () {
        emit(const TasksError(AppConstants.defaultErrorMessage));
      },
    );
  }

  Future<void> updateTaskAssistModeLogic({
    required String taskId,
    bool assistMode = false,
  }) async {
    emit(TasksLoading());

    final result = await updateTaskAssistMode(UpdateTaskAssistModeParams(
      taskId: taskId,
      assistMode: assistMode,
    ));

    result.maybeWhen(
      success: (_) {
        emit(TasksLoaded(data: null));
      },
      apiFailure: (error, _) {
        emit(TasksError(ApiExceptions.getErrorMessage(error)));
      },
      orElse: () {
        emit(const TasksError(AppConstants.defaultErrorMessage));
      },
    );
  }

  @override
  Future<void> onAppStartLazy() async {
    await Future.value();
  }
}
