// ignore_for_file: unused_field

import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';

class SessionRepoImpl implements SessionRepo {
  final SessionDataSource _sessionDataSource;
  SessionRepoImpl(
    this._sessionDataSource,
  );

  @override
  Future<ApiResult<CreateSessionResponse>> createSession(
    CreateSessionParam params,
  ) {
    return apiInterceptor(
      _sessionDataSource.createSession(params),
    );
  }

  @override
  Future<ApiResult<void>> createMessage(CreateMessageParams params) {
    return apiInterceptor(
      _sessionDataSource.createMessage(params),
    );
  }

  @override
  Future<ApiResult<List<Message>>> getSessionMessages(String sessionId) {
    return apiInterceptor(
      _sessionDataSource.getSessionMessages(sessionId),
    );
  }

  @override
  Future<ApiResult<String>> createSessionToken(String sessionId) {
    return apiInterceptor(
      _sessionDataSource.createSessionToken(sessionId),
    );
  }

  @override
  Future<ApiResult<void>> createWaitlist(CreateWaitlistParams params) {
    return apiInterceptor(
      _sessionDataSource.createWaitlist(params),
    );
  }
}
