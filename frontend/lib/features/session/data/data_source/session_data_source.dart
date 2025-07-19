import 'package:frontend/features/session/index.dart';

/// Defines a contract/template for classes impelementing the [SessionsDataSource].
abstract class SessionDataSource {
  Future<CreateSessionResponse> createSession(
    CreateSessionParam params,
  );
  Future<void> createMessage(CreateMessageParams params);
  Future<List<Message>> getSessionMessages(String sessionId);
  Future<String> createSessionToken(String sessionId);
  Future<void> createWaitlist(CreateWaitlistParams params);
}
