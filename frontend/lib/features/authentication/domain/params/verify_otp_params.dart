import 'dart:convert';

import 'package:frontend/features/authentication/data/index.dart';

/// Defines parameters needed to call the [updateEmail] and [sendPasswordResetEmail] functions on the [AuthenticationDataSource] class.
///
/// The [[updateEmail] function updates the user's email.
///
/// The [[sendPasswordResetEmail] function sends a password reset mail to the user's email.
class VerifyOtpParam {
  /// The registering user's email address.
  final String emailAddress;

  /// The registering user's otp code..
  final int otpCode;

  VerifyOtpParam({
    required this.emailAddress,
    required this.otpCode,
  });

  Map<String, dynamic> toMap() {
    return {
      "email_address": emailAddress,
      "otp_code": otpCode,
    };
  }

  String toJson() => json.encode(toMap());

  VerifyOtpParam copyWith({
    String? emailAddress,
    int? otpCode,
  }) {
    return VerifyOtpParam(
      emailAddress: emailAddress ?? this.emailAddress,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}
