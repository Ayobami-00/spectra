import 'package:frontend/core/index.dart';
import 'package:frontend/features/tasks/index.dart';

class GetTaskGrindScore
    with UseCases<ApiResult<TaskGrindScoreResponse>, String> {
  final TasksRepo tasksRepo;
  GetTaskGrindScore(this.tasksRepo);

  @override
  Future<ApiResult<TaskGrindScoreResponse>> call(String username) {
    return tasksRepo.getTaskGrindScore(username);
  }
}
