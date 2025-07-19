import 'dart:convert';

import 'package:frontend/features/authentication/data/index.dart';

/// Defines parameters needed to call the [signIn] function on the [AuthenticationDataSource] class.
///
/// The [signIn] function signs in the user with email and password.
class SignInParam {
  /// The registering user's email address.
  final String? emailAddress;

  /// The registering user's created password.
  final String? password;

  SignInParam({
    this.emailAddress,
    this.password,
  });

  SignInParam copyWith({
    String? emailAddress,
    String? password,
    bool? isVerify,
  }) {
    return SignInParam(
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': emailAddress,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}
