import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class CreateTask with UseCases<ApiResult<CreateTaskResponse>, CreateTaskParam> {
  final TasksRepo tasksRepo;
  CreateTask(
    this.tasksRepo,
  );

  @override
  Future<ApiResult<CreateTaskResponse>> call(CreateTaskParam params) {
    return tasksRepo.createTask(params);
  }
}
