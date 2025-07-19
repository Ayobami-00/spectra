import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class StartWorkflow
    with UseCases<ApiResult<StartWorkflowResponse>, StartWorkflowParams> {
  final TasksRepo _repo;

  StartWorkflow(this._repo);

  @override
  Future<ApiResult<StartWorkflowResponse>> call(StartWorkflowParams params) {
    return _repo.startWorkflow(
      taskId: params.taskId,
      workflowId: params.workflowId,
      stepId: params.stepId,
    );
  }
}

class StartWorkflowParams {
  final String taskId;
  final String workflowId;
  final String stepId;

  StartWorkflowParams({
    required this.taskId,
    required this.workflowId,
    required this.stepId,
  });
}
