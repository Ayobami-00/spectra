import 'package:frontend/features/authentication/data/models/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

/// Defines a contract/template for classes impelementing the [AuthenticationDataSource].
abstract class AuthenticationDataSource {
  Future<Option<User>> getSignedInUser();

  Future<Option<Unit>> register(
    RegisterParam params,
  );

  Future<Option<Unit>> signIn(
    SignInParam params,
  );

  Future<EmailVerificationResponse> verifyEmail(PostEmailParam params);

  Future<Option<bool>> sendOtp(PostEmailParam params);

  Future<OtpVerificationResponse> verifyOtp(VerifyOtpParam params);

  Future<Option<bool>> sendPasswordResetEmail(PostEmailParam params);

  Future<Option<bool>> updateDeviceInfo();

  Future<void> signOut();

  Future<Option<User>> getUserByUsername(String username);
  Future<Option<User>> getUserByEmail(String email);
}
