import 'package:frontend/features/authentication/domain/use_cases/send_otp.dart';
import 'package:frontend/features/authentication/domain/use_cases/verify_otp.dart';
import 'package:bloc/bloc.dart';
import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:frontend/features/authentication/presentation/listeners/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState>
    implements OnAppLogout {
  GetSignedInUser getSignedInUser;
  Register register;
  SendPasswordResetEmail sendPasswordResetEmail;
  SignIn signIn;
  SignOut signOut;
  VerifyEmail verifyEmail;
  UpdateDeviceInfo updateDeviceInfo;
  SendOtp sendOtp;
  VerifyOtp verifyOtp;
  GetUserByUsername getUserByUsername;
  GetUserByEmail getUserByEmail;

  //Sign Up Bloc Values
  String? signUpUsername;
  String? signUpEmail;
  String? signUpPassword;

  //Sign In Bloc Values
  String? signInEmail;
  String? signInPassword;

  //Forgot Password Bloc Values
  String? forgotPasswordEmail;

  Function(BuildContext context)? onOtpVerificationSuccessfull;

  void resetState() {
    signUpUsername = null;
    signUpEmail = null;
    signUpPassword = null;

    signInEmail = null;
    signInPassword = null;

    forgotPasswordEmail = null;
  }

  /// The auth listeners.
  final authListeners = <String, Object?>{};

  AuthenticationCubit(
    this.getSignedInUser,
    this.register,
    this.sendPasswordResetEmail,
    this.signIn,
    this.signOut,
    this.verifyEmail,
    this.updateDeviceInfo,
    this.verifyOtp,
    this.sendOtp,
    this.getUserByUsername,
    this.getUserByEmail,
  ) : super(AuthenticationInitial());

  void registerAuthListeners(List<Object?> listeners) {
    for (final element in listeners) {
      // generate a unique id for the element
      final id = element.toString().hashCode.toString();

      authListeners[id] = element;
    }
  }

  Future<void> sendOnAppLogoutEvent() {
    final values = authListeners.values
        .whereType<OnAppLogout>()
        .map((e) => e.onAppLogout());

    return Future.wait(values);
  }

  Future<void> sendOnAppStartPriorityEvent() {
    final values = authListeners.values
        .whereType<OnAppStartPriority>()
        .map((e) => e.onAppStartPriority());

    return Future.wait(values);
  }

  Future<void> sendOnAppStartLazyEvent() {
    final values = authListeners.values
        .whereType<OnAppStartLazy>()
        .map((e) => e.onAppStartLazy());

    return Future.wait(values);
  }

  Future getSignedInUserLogic() async {
    final param = NoParams();
    final response = await getSignedInUser(param);
    response.maybeWhen(
      success: (data) => data.fold(
        () => emit(const AuthenticationSuccessful(data: null)),
        (value) => emit(AuthenticationSuccessful<User>(data: value)),
      ),
      apiFailure: (exception, _) =>
          emit(AuthenticationError(ApiExceptions.getErrorMessage(exception))),
      orElse: () =>
          emit(const AuthenticationError(AppConstants.defaultErrorMessage)),
    );
  }

  Future registerLogic(RegisterParam params) async {
    emit(AuthenticationLoading());
    final response = await register(params);
    return response.maybeWhen(
      success: (data) => data.fold(
        () => AppConstants.defaultErrorMessage,
        (value) => true,
      ),
      apiFailure: (exception, _) => ApiExceptions.getErrorMessage(exception),
      orElse: () => AppConstants.defaultErrorMessage,
    );
  }

  Future sendPasswordResetEmailLogic() async {
    emit(ForgotPasswordLoading());
    final params = PostEmailParam(emailAddress: forgotPasswordEmail!);
    final response = await sendPasswordResetEmail(params);
    response.maybeWhen(
      success: (data) => data.fold(
        () => emit(const AuthenticationError(AppConstants.defaultErrorMessage)),
        (value) => emit(ForgotPasswordCompleted<bool>(data: value)),
      ),
      apiFailure: (exception, _) =>
          emit(AuthenticationError(ApiExceptions.getErrorMessage(exception))),
      orElse: () =>
          emit(const AuthenticationError(AppConstants.defaultErrorMessage)),
    );
  }

  Future signInLogic() async {
    emit(AuthenticationLoading());
    final params = SignInParam(
      emailAddress: signInEmail ?? signUpEmail,
      password: signInPassword,
    );
    final response = await signIn(params);
    return response.maybeWhen(
      success: (data) => data.fold(
        () => AppConstants.defaultErrorMessage,
        (value) => true,
      ),
      apiFailure: (exception, _) => ApiExceptions.getErrorMessage(exception),
      orElse: () => AppConstants.defaultErrorMessage,
    );
  }

  Future signOutLogic() async {
    final param = NoParams();
    final response = await signOut(param);
    return response.maybeWhen(
      success: (data) async {
        await sendOnAppLogoutEvent();
        return const AuthenticationSuccessful<void>(data: null);
      },
      apiFailure: (exception, _) =>
          emit(AuthenticationError(ApiExceptions.getErrorMessage(exception))),
      orElse: () =>
          emit(const AuthenticationError(AppConstants.defaultErrorMessage)),
    );
  }

  Future<EmailVerificationResponse> verifyEmailLogic(
    PostEmailParam params,
  ) async {
    final response = await verifyEmail(params);
    return response.maybeWhen(
      success: (data) => data,
      apiFailure: (exception, _) => EmailVerificationResponse.hasError(),
      orElse: () => EmailVerificationResponse.hasError(),
    );
  }

  Future<bool> updateDeviceInfoLogic() async {
    final param = NoParams();
    final response = await updateDeviceInfo(param);
    return response.maybeWhen(
      success: (data) => data.fold(() => false, (data) => data),
      apiFailure: (exception, _) => false,
      orElse: () => false,
    );
  }

  Future<bool> sendOtpLogic(String emailAddress) async {
    final response = await sendOtp(PostEmailParam(emailAddress: emailAddress));
    return response.maybeWhen(
      success: (data) => data.fold(() => false, (data) => data),
      apiFailure: (exception, _) => false,
      orElse: () => false,
    );
  }

  Future<OtpVerificationResponse> verifyOtpLogic(
    String emailAddress,
    int otpCode,
  ) async {
    final response = await verifyOtp(VerifyOtpParam(
      emailAddress: emailAddress,
      otpCode: otpCode,
    ));
    return response.maybeWhen(
      success: (data) => data,
      apiFailure: (exception, _) => OtpVerificationResponse.hasError(
        ApiExceptions.getErrorMessage(exception),
      ),
      orElse: () => OtpVerificationResponse.hasError(
        AppConstants.defaultErrorMessage,
      ),
    );
  }

  Future<bool> getUserByUsernameLogic(String username) async {
    final response = await getUserByUsername(username);
    return response.maybeWhen(
      success: (data) => data.fold(() => false, (_) => true),
      apiFailure: (_, __) => false,
      orElse: () => false,
    );
  }

  Future<bool> getUserByEmailLogic(String email) async {
    final response = await getUserByEmail(email);
    return response.maybeWhen(
      success: (data) => data.fold(() => false, (_) => true),
      apiFailure: (_, __) => false,
      orElse: () => false,
    );
  }

  @override
  Future<void> onAppLogout() {
    resetState();
    return Future.value();
  }
}
