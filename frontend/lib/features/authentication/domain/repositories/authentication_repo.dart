import 'package:frontend/core/api/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/params/index.dart';
import 'package:dartz/dartz.dart';

/// Defines a contract/template for classes impelementing the [AuthenticationRepo].
abstract class AuthenticationRepo {
  Future<ApiResult<Option<User>>> getSignedInUser();

// Done
  Future<ApiResult<Option<Unit>>> register(
    RegisterParam params,
  );

  Future<ApiResult<Option<Unit>>> signIn(
    SignInParam params,
  );

  Future<ApiResult<Option<bool>>> sendPasswordResetEmail(PostEmailParam params);

  Future<ApiResult<Option<bool>>> sendOtp(PostEmailParam params);

  Future<ApiResult<OtpVerificationResponse>> verifyOtp(VerifyOtpParam params);

  Future<ApiResult<void>> signOut();

  Future<ApiResult<EmailVerificationResponse>> verifyEmail(
    PostEmailParam params,
  );

  Future<ApiResult<Option<bool>>> updateDeviceInfo();

  Future<ApiResult<Option<User>>> getUserByUsername(String username);
  Future<ApiResult<Option<User>>> getUserByEmail(String email);
}
