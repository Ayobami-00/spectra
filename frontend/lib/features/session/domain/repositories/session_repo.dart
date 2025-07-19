import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';

/// Defines a contract/template for classes impelementing the [TasksRepo].
abstract class SessionRepo {
  Future<ApiResult<CreateSessionResponse>> createSession(
    CreateSessionParam params,
  );

  Future<ApiResult<void>> createMessage(CreateMessageParams params);

  Future<ApiResult<List<Message>>> getSessionMessages(String sessionId);

  Future<ApiResult<String>> createSessionToken(String sessionId);

  Future<ApiResult<void>> createWaitlist(CreateWaitlistParams params);
}
