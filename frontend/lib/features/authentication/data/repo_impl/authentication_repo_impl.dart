import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/data_source/index.dart';
import 'package:frontend/features/authentication/data/models/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepoImpl extends AuthenticationRepo {
  final AuthenticationDataSource _authenticationDataSource;
  AuthenticationRepoImpl(
    this._authenticationDataSource,
  );
  @override
  Future<ApiResult<Option<User>>> getSignedInUser() {
    return apiInterceptor(_authenticationDataSource.getSignedInUser());
  }

  @override
  Future<ApiResult<Option<Unit>>> register(
    RegisterParam params,
  ) {
    return apiInterceptor(
      _authenticationDataSource.register(params),
    );
  }

  @override
  Future<ApiResult<Option<bool>>> sendPasswordResetEmail(
    PostEmailParam params,
  ) {
    return apiInterceptor(
      _authenticationDataSource.sendPasswordResetEmail(params),
    );
  }

  @override
  Future<ApiResult<Option<Unit>>> signIn(
    SignInParam params,
  ) {
    return apiInterceptor(
      _authenticationDataSource.signIn(params),
    );
  }

  @override
  Future<ApiResult<void>> signOut() {
    return apiInterceptor(_authenticationDataSource.signOut());
  }

  @override
  Future<ApiResult<EmailVerificationResponse>> verifyEmail(
    PostEmailParam params,
  ) {
    return apiInterceptor(_authenticationDataSource.verifyEmail(params));
  }

  @override
  Future<ApiResult<Option<bool>>> updateDeviceInfo() {
    return apiInterceptor(_authenticationDataSource.updateDeviceInfo());
  }

  @override
  Future<ApiResult<Option<bool>>> sendOtp(PostEmailParam params) {
    return apiInterceptor(_authenticationDataSource.sendOtp(params));
  }

  @override
  Future<ApiResult<OtpVerificationResponse>> verifyOtp(VerifyOtpParam params) {
    return apiInterceptor(_authenticationDataSource.verifyOtp(params));
  }

  @override
  Future<ApiResult<Option<User>>> getUserByUsername(String username) {
    return apiInterceptor(
        _authenticationDataSource.getUserByUsername(username));
  }

  @override
  Future<ApiResult<Option<User>>> getUserByEmail(String email) {
    return apiInterceptor(_authenticationDataSource.getUserByEmail(email));
  }
}
