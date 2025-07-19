import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class AddTaskMessageParams {
  final String taskId;
  final Map<String, dynamic> message;

  AddTaskMessageParams({
    required this.taskId,
    required this.message,
  });
}

class AddTaskMessage with UseCases<ApiResult<void>, AddTaskMessageParams> {
  final TasksRepo _repo;

  AddTaskMessage(this._repo);

  @override
  Future<ApiResult<void>> call(AddTaskMessageParams params) {
    return _repo.addTaskMessage(
      taskId: params.taskId,
      message: params.message,
    );
  }
}
