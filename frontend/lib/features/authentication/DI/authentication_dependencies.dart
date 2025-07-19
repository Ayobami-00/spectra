import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:frontend/features/authentication/domain/use_cases/send_otp.dart';
import 'package:frontend/features/authentication/domain/use_cases/verify_otp.dart';
import 'package:frontend/features/authentication/presentation/index.dart';

/// Registers Authentication feature dependencies
void setUpAuthenticationDependencies() {
  // Register usecases dependencies.
  locator.registerLazySingleton(() => GetSignedInUser(locator()));
  locator.registerLazySingleton(() => Register(locator()));
  locator.registerLazySingleton(() => SendPasswordResetEmail(locator()));
  locator.registerLazySingleton(() => SignIn(locator()));
  locator.registerLazySingleton(() => SignOut(locator()));
  locator.registerLazySingleton(() => VerifyEmail(locator()));
  locator.registerLazySingleton(() => UpdateDeviceInfo(locator()));
  locator.registerLazySingleton(() => SendOtp(locator()));
  locator.registerLazySingleton(() => VerifyOtp(locator()));
  locator.registerLazySingleton(() => GetUserByUsername(locator()));
  locator.registerLazySingleton(() => GetUserByEmail(locator()));

  // Register repository dependencies.
  locator.registerLazySingleton<AuthenticationRepo>(
    () => AuthenticationRepoImpl(
      locator(),
    ),
  );

  // Register datasource dependencies.
  locator.registerLazySingleton<AuthenticationDataSource>(
    () => AuthenticationDataSourceImpl(
      locator(),
      AmConfig.config.baseApiUrl!,
    ),
  );

  // Register the AuthenticationCubit
  locator.registerLazySingleton(() => AuthenticationCubit(
        locator(), // GetSignedInUser
        locator(), // Register
        locator(), // SendPasswordResetEmail
        locator(), // SignIn
        locator(), // SignOut
        locator(), // VerifyEmail
        locator(), // UpdateDeviceInfo
        locator(), // VerifyOtp
        locator(), // SendOtp
        locator(), // GetUserByUsername
        locator(), // GetUserByEmail
      ));
}
