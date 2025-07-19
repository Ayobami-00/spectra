part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSuccessful<T> extends AuthenticationState {
  final T data;
  const AuthenticationSuccessful({
    required this.data,
  }) : super();

  @override
  List<Object?> get props => [data];
}

class AuthenticationCompleted<T> extends AuthenticationState {
  final T data;
  const AuthenticationCompleted({
    required this.data,
  }) : super();

  @override
  List<Object?> get props => [data];
}

class VerifyPasswordSuccessful<T> extends AuthenticationState {
  final T data;
  const VerifyPasswordSuccessful({
    required this.data,
  }) : super();

  @override
  List<Object?> get props => [data];
}

class ForgotPasswordCompleted<T> extends AuthenticationState {
  final T data;
  const ForgotPasswordCompleted({
    required this.data,
  }) : super();

  @override
  List<Object?> get props => [data];
}

class AuthenticationError extends AuthenticationState {
  final String errorMessage;

  const AuthenticationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
