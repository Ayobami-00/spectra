import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class UpdateTaskAssistModeParams {
  final String taskId;
  final bool assistMode;

  UpdateTaskAssistModeParams({
    required this.taskId,
    this.assistMode = false,
  });
}

class UpdateTaskAssistMode
    with UseCases<ApiResult<void>, UpdateTaskAssistModeParams> {
  final TasksRepo _repo;

  UpdateTaskAssistMode(this._repo);

  @override
  Future<ApiResult<void>> call(UpdateTaskAssistModeParams params) {
    return _repo.updateTaskAssistMode(
      taskId: params.taskId,
      assistMode: params.assistMode,
    );
  }
}
