import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class TriggerTaskWorkflow
    with UseCases<ApiResult<TriggerTaskWorkflowResponse>, String> {
  final TasksRepo tasksRepo;

  TriggerTaskWorkflow(this.tasksRepo);

  @override
  Future<ApiResult<TriggerTaskWorkflowResponse>> call(String taskId) {
    return tasksRepo.triggerTaskWorkflow(taskId);
  }
}
