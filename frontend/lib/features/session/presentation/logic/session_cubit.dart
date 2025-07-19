import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';
import 'dart:convert';

import '../../../authentication/presentation/listeners/index.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> implements OnAppStartLazy {
  final CreateSession createSession;
  final CreateMessage createMessage;
  final GetSessionMessages getSessionMessages;
  final WebSocketService webSocketService;
  final CreateSessionToken createSessionToken;
  final CreateWaitlist createWaitlist;

  Session? session;
  List<Message> messages = [];
  StreamSubscription? _wsSubscription;

  SessionCubit(
    this.createSession,
    this.createMessage,
    this.getSessionMessages,
    this.webSocketService,
    this.createSessionToken,
    this.createWaitlist,
  ) : super(SessionInitial());

  void disconnectWebSocket() {
    _wsSubscription?.cancel();
    _wsSubscription = null;
    webSocketService.disconnect();
  }

  @override
  Future<void> close() {
    disconnectWebSocket();
    return super.close();
  }

  Future<CreateSessionResponse> createSessionLogic(bool isPublic) async {
    emit(SessionLoading());

    final params = CreateSessionParam(
      isPublic: isPublic,
    );

    final response = await createSession(params);
    return response.maybeWhen(
      success: (data) {
        session = data.session;
        emit(SessionLoaded(data: data));
        return data;
      },
      apiFailure: (exception, _) {
        final errorResponse = CreateSessionResponse.hasError(
          ApiExceptions.getErrorMessage(exception),
        );
        emit(SessionError(errorResponse.message ?? 'Unknown error'));
        if (exception == const ApiExceptions.badRequest()) {
          return CreateSessionResponse.hasError(
            AppConstants.maxSessionsReachedMessage,
          );
        }
        return errorResponse;
      },
      orElse: () {
        final errorResponse = CreateSessionResponse.hasError(
          AppConstants.defaultErrorMessage,
        );
        emit(SessionError(errorResponse.message ?? 'Unknown error'));
        return errorResponse;
      },
    );
  }

  Future<bool> createMessageLogic({
    required String sessionId,
    required String content,
    required String role,
  }) async {
    emit(SessionLoading());

    final params = CreateMessageParams(
      sessionId: sessionId,
      content: content,
      role: role,
    );

    final response = await createMessage(params);
    return response.maybeWhen(
      success: (_) {
        emit(const SessionLoaded(data: null));
        return true;
      },
      apiFailure: (exception, _) {
        emit(SessionError(ApiExceptions.getErrorMessage(exception)));
        return false;
      },
      orElse: () {
        emit(const SessionError(AppConstants.defaultErrorMessage));
        return false;
      },
    );
  }

  Future<List<Message>> getMessagesLogic(String sessionId) async {
    emit(SessionLoading());

    final response = await getSessionMessages(sessionId);

    return response.maybeWhen(
      success: (messages) {
        this.messages = messages;
        emit(SessionLoaded(data: messages));
        return messages;
      },
      apiFailure: (exception, _) {
        emit(SessionError(ApiExceptions.getErrorMessage(exception)));
        return [];
      },
      orElse: () {
        emit(const SessionError(AppConstants.defaultErrorMessage));
        return [];
      },
    );
  }

  Future<String?> createSessionTokenLogic(String sessionId) async {
    emit(SessionLoading());

    final response = await createSessionToken(sessionId);
    return response.maybeWhen(
      success: (token) {
        emit(SessionLoaded(data: token));
        return token;
      },
      apiFailure: (exception, _) {
        print(exception);
        emit(SessionError(ApiExceptions.getErrorMessage(exception)));
        if (exception == const ApiExceptions.unauthorisedRequest()) {
          return AppConstants.maxMessagesReachedMessage;
        }
        return null;
      },
      orElse: () {
        emit(const SessionError(AppConstants.defaultErrorMessage));
        return null;
      },
    );
  }

  Future<bool> createWaitlistLogic(String email, String planType) async {
    emit(SessionLoading());

    final params = CreateWaitlistParams(
      email: email,
      planType: planType,
    );

    final response = await createWaitlist(params);
    return response.maybeWhen(
      success: (_) {
        emit(const SessionLoaded(data: null));
        return true;
      },
      apiFailure: (exception, _) {
        emit(SessionError(ApiExceptions.getErrorMessage(exception)));
        return false;
      },
      orElse: () {
        emit(const SessionError(AppConstants.defaultErrorMessage));
        return false;
      },
    );
  }

  @override
  Future<void> onAppStartLazy() async {
    await Future.value();
  }
}
