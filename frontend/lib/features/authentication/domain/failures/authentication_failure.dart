/// Defines a class that holds all the possible [AuthenticationFailure] that can result from the [AuthenticationDataSource].
class AuthenticationFailure {
  const AuthenticationFailure();

  /// Defines the case of a [AuthenticationFailure] server error.
  factory AuthenticationFailure.serverError() {
    return const AuthenticationFailure();
  }

  /// Defines the case of a [AuthenticationFailure] email already in use error.
  factory AuthenticationFailure.emailAlreadyInUse() {
    return const AuthenticationFailure();
  }

  /// Defines the case of a [AuthenticationFailure] invalid email and password combination error.
  factory AuthenticationFailure.invalidEmailAndPasswordCombination() {
    return const AuthenticationFailure();
  }

  /// Defines the case of a [AuthenticationFailure] email not verified.
  factory AuthenticationFailure.emailNotVerified() {
    return const AuthenticationFailure();
  }
}
