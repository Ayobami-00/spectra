import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/domain/repositories/session_repo.dart';

class CreateSessionToken with UseCases<ApiResult<String>, String> {
  final SessionRepo sessionRepo;

  CreateSessionToken(this.sessionRepo);

  @override
  Future<ApiResult<String>> call(String sessionId) {
    return sessionRepo.createSessionToken(sessionId);
  }
}
