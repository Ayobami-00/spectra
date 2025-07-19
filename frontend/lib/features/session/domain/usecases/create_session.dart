import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';

class CreateSession
    with UseCases<ApiResult<CreateSessionResponse>, CreateSessionParam> {
  final SessionRepo sessionRepo;
  CreateSession(
    this.sessionRepo,
  );

  @override
  Future<ApiResult<CreateSessionResponse>> call(CreateSessionParam params) {
    return sessionRepo.createSession(params);
  }
}
