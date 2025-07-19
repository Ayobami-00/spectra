// ignore_for_file: unused_field

import 'package:frontend/core/api/api_client/index.dart';
import 'package:frontend/features/session/index.dart';

class SessionDataSourceImpl implements SessionDataSource {
  static const _createSessionPath = '/sessions';
  final FeApiClient _apiClient;
  final String _baseApiUrl;
  final String _assistantApiUrl;
  final String _assistantApiKey;
  final String _assistantSuperadminApiEmail;
  final String _assistantSuperadminApiPassword;
  String? _assistantApiAccessToken;

  SessionDataSourceImpl(
    this._apiClient,
    this._baseApiUrl,
    this._assistantApiUrl,
    this._assistantApiKey,
    this._assistantSuperadminApiEmail,
    this._assistantSuperadminApiPassword,
  );

  Future<void> _ensureAuthenticated() async {
    if (_assistantApiAccessToken != null) return;

    try {
      final loginResponse = await _apiClient.post(
        '$_baseApiUrl/auth/login',
        data: {
          'email': _assistantSuperadminApiEmail,
          'password': _assistantSuperadminApiPassword,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );

      _assistantApiAccessToken = loginResponse.data['access_token'];
    } catch (e) {
      // If login fails, try to create the user
      final _ = await _apiClient.post(
        '$_baseApiUrl/users',
        data: {
          'email': _assistantSuperadminApiEmail,
          'password': _assistantSuperadminApiPassword,
          'username': _assistantSuperadminApiEmail,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Try logging in again after user creation
      final loginResponse = await _apiClient.post(
        '$_baseApiUrl/auth/login',
        data: {
          'email': _assistantSuperadminApiEmail,
          'password': _assistantSuperadminApiPassword,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );

      _assistantApiAccessToken = loginResponse.data['access_token'];
    }
  }

  @override
  Future<CreateSessionResponse> createSession(
    CreateSessionParam params,
  ) async {
    final url = params.isPublic
        ? '$_baseApiUrl/public$_createSessionPath'
        : '$_baseApiUrl$_createSessionPath';

    final response = await _apiClient.post(
      url,
      data: params.toMap(),
    );

    return CreateSessionResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> createMessage(CreateMessageParams params) async {
    final url = '$_baseApiUrl/public/sessions/${params.sessionId}/messages';

    await _apiClient.post(
      url,
      data: params.toMap(),
    );
  }

  @override
  Future<List<Message>> getSessionMessages(String sessionId) async {
    final url = '$_baseApiUrl/public/sessions/$sessionId/messages';

    final response = await _apiClient.get(url);

    final List<dynamic> messagesJson = response.data ?? [];
    return messagesJson.map((json) => Message.fromJson(json)).toList();
  }

  @override
  Future<String> createSessionToken(String sessionId) async {
    final response = await _apiClient.post(
      '$_assistantApiUrl/v1/session/$sessionId/token',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_assistantApiAccessToken',
        'X-API-KEY': _assistantApiKey,
      },
    );

    return response.data['token'];
  }

  @override
  Future<void> createWaitlist(CreateWaitlistParams params) async {
    await _apiClient.post(
      '$_baseApiUrl/public/waitlist',
      data: params.toMap(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}
