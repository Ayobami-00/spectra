import 'package:frontend/features/tasks/index.dart';

import '../../../../core/index.dart';

class GetTaskMessages
    with UseCases<ApiResult<GetTaskMessagesResponse>, String> {
  final TasksRepo _repo;

  GetTaskMessages(this._repo);

  @override
  Future<ApiResult<GetTaskMessagesResponse>> call(String taskId) {
    return _repo.getTaskMessages(taskId);
  }
}
