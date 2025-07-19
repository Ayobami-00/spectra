import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class GetWorkflowSteps
    with UseCases<ApiResult<GetWorkflowStepsResponse>, String> {
  final TasksRepo tasksRepo;

  GetWorkflowSteps(this.tasksRepo);

  @override
  Future<ApiResult<GetWorkflowStepsResponse>> call(String workflowId) {
    return tasksRepo.getWorkflowStepsByWorkflowId(workflowId);
  }
}
