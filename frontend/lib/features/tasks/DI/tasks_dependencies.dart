import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

/// Registers Authentication feature dependencies
void setUpTasksCoreDependencies() {
  // Register usecases dependencies.
  locator.registerLazySingleton(() => CreateTask(locator()));
  locator.registerLazySingleton(() => GetTaskGrindScore(locator()));
  locator.registerLazySingleton(() => TriggerTaskWorkflow(locator()));
  locator.registerLazySingleton(() => GetWorkflowByTaskId(locator()));
  locator.registerLazySingleton(() => GetWorkflowSteps(locator()));
  locator.registerLazySingleton(() => StartWorkflow(locator()));
  locator.registerLazySingleton(() => GetTaskMessages(locator()));
  locator.registerLazySingleton(() => AddTaskMessage(locator()));
  locator.registerLazySingleton(() => UpdateTaskAssistMode(locator()));

  // Register repository dependencies.
  locator.registerLazySingleton<TasksRepo>(
    () => TasksRepoImpl(
      locator(),
    ),
  );

  // Register datasource dependencies.
  locator.registerLazySingleton<TasksDataSource>(
    () => TasksDataSourceImpl(
      locator(),
      AmConfig.config.baseApiUrl!,
      AmConfig.config.assistantApiUrl!,
      AmConfig.config.assistantApiKey!,
      AmConfig.config.assistantSuperadminApiEmail!,
      AmConfig.config.assistantSuperadminApiPassword!,
    ),
  );

  // Update TasksCubit registration if needed
  locator.registerFactory(
    () => TasksCubit(
      locator(), // CreateTask
      locator(), // GetTaskGrindScore
      locator(), // TriggerTaskWorkflow
      locator(), // GetWorkflowByTaskId
      locator(), // GetWorkflowSteps
      locator(), // StartWorkflow
      locator(), // GetTaskMessages
      locator(), // AddTaskMessages
      locator(), // UpdateTaskAssistMode
    ),
  );
}
