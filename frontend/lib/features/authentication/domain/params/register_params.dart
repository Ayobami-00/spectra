import 'dart:convert';

import 'package:frontend/features/authentication/data/index.dart';

/// Defines parameters needed to call the [Register] function on the [AuthenticationDataSource] class.
///
/// The [Register] function registers the user with the fields below.
class RegisterParam {
  final String username;
  final String email;
  final String password;

  RegisterParam({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());

  RegisterParam copyWith({
    String? username,
    String? email,
    String? password,
  }) {
    return RegisterParam(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
