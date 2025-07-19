import 'package:frontend/features/authentication/data/index.dart';

/// Defines parameters needed to call the [updateEmail] and [sendPasswordResetEmail] functions on the [AuthenticationDataSource] class.
///
/// The [[updateEmail] function updates the user's email.
///
/// The [[sendPasswordResetEmail] function sends a password reset mail to the user's email.
class PostEmailParam {
  /// The registering user's email address.
  final String emailAddress;

  PostEmailParam({
    required this.emailAddress,
  });
}
