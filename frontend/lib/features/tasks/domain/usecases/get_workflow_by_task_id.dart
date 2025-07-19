import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class GetWorkflowByTaskId
    with UseCases<ApiResult<GetWorkflowResponse>, String> {
  final TasksRepo tasksRepo;

  GetWorkflowByTaskId(this.tasksRepo);

  @override
  Future<ApiResult<GetWorkflowResponse>> call(String taskId) {
    return tasksRepo.getWorkflowByTaskId(taskId);
  }
}
