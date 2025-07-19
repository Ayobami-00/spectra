import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';

class CreateMessage with UseCases<ApiResult<void>, CreateMessageParams> {
  final SessionRepo sessionRepo;

  CreateMessage(this.sessionRepo);

  @override
  Future<ApiResult<void>> call(CreateMessageParams params) {
    return sessionRepo.createMessage(params);
  }
}
