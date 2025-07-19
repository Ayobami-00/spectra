import 'package:frontend/core/api/api_client/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:frontend/core/index.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthenticationDataSourceImpl implements AuthenticationDataSource {
  AuthenticationDataSourceImpl(
    this._apiClient,
    this._baseApiUrl,
  );

  static const _signInPath = '/v1/auth/login';

  static const _registerPath = '/v1/superadmin/register';

  static const _verifyEmailUrl = '/v1/user/email/verify';

  static const _updateDeviceInfo = '/v1/user/device_info/update';

  static const _sendOtpPath = '/v1/auth/otp';

  static const _verifyOtpPath = '/v1/auth/otp/verify';

  static const _getUserByUsernamePath = '/users/username/';
  static const _getUserByEmailPath = '/users/email/';

  final FeApiClient _apiClient;
  final String _baseApiUrl;

  @override
  Future<Option<User>> getSignedInUser() async {
    return Future.value(none());
  }

  @override
  Future<Option<Unit>> register(
    RegisterParam params,
  ) async {
    final response = await _apiClient.post(
      '$_baseApiUrl$_registerPath',
      data: params.toJson(),
    );

    if (response.statusCode != 201) {
      return none();
    }

    final accessToken = response.data["data"]["access_token"];

    return some(unit);
  }

  @override
  Future<Option<bool>> sendPasswordResetEmail(PostEmailParam params) async {
    return Future.value(optionOf(true));
  }

  @override
  Future<Option<Unit>> signIn(
    SignInParam params,
  ) async {
    final response = await _apiClient.post(
      '$_baseApiUrl$_signInPath',
      data: params.toJson(),
    );

    if (response.statusCode != 200) {
      return none();
    }

    final accessToken = response.data["data"]["access_token"];

    return some(unit);
  }

  @override
  Future<void> signOut() {
    return Future.wait([
      // _firebaseAuth.signOut(),
    ]);
  }

  @override
  Future<EmailVerificationResponse> verifyEmail(PostEmailParam params) async {
    final response = await _apiClient.get(
      '$_baseApiUrl$_verifyEmailUrl?email=${params.emailAddress}',
    );

    return EmailVerificationResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<Option<bool>> updateDeviceInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final mobileVersion = packageInfo.version;
    const deviceType = kIsWeb ? "web" : "N/A";

    final Map<String, dynamic> data = {};

    data["device_type"] = deviceType;
    data["version"] = mobileVersion;

    await _apiClient.patch(
      '$_baseApiUrl$_updateDeviceInfo',
      data: data,
    );

    return some(true);
  }

  @override
  Future<Option<bool>> sendOtp(PostEmailParam params) async {
    await _apiClient.post(
      '$_baseApiUrl$_sendOtpPath',
      data: {
        "email_address": params.emailAddress,
      },
    );

    return some(true);
  }

  @override
  Future<OtpVerificationResponse> verifyOtp(VerifyOtpParam params) async {
    final response = await _apiClient.post(
      '$_baseApiUrl$_verifyOtpPath',
      data: {
        "email_address": params.emailAddress,
        "otp_code": params.otpCode,
      },
    );

    return OtpVerificationResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<Option<User>> getUserByUsername(String username) async {
    try {
      final response = await _apiClient.get(
        '$_baseApiUrl$_getUserByUsernamePath$username',
      );

      if (response.statusCode != 200) {
        return none();
      }

      final user = User.fromJson(response.data['data']);
      return some(user);
    } catch (e) {
      return none();
    }
  }

  @override
  Future<Option<User>> getUserByEmail(String email) async {
    try {
      final response = await _apiClient.get(
        '$_baseApiUrl$_getUserByEmailPath$email',
      );

      if (response.statusCode != 200) {
        return none();
      }

      final user = User.fromJson(response.data['data']);
      return some(user);
    } catch (e) {
      return none();
    }
  }
}
