import 'package:flutter/foundation.dart';

@immutable
class SuperadminDetails {
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? version;
  final String? deviceType;
  final String? email;
  final String? phoneNumber;
  final bool hasError;
  final String? errorMessage;

  const SuperadminDetails({
    this.firstName,
    this.lastName,
    this.companyName,
    this.version,
    this.deviceType,
    this.email,
    this.phoneNumber,
    this.errorMessage,
    this.hasError = false,
  });

  factory SuperadminDetails.fromJson(Map<String, dynamic> json) {
    return SuperadminDetails(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      companyName: json['company_name'] as String?,
      email: json['email'] as String?,
      version: json['version'] as String?,
      deviceType: json['device_type'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  factory SuperadminDetails.hasError(String errorMessage) {
    return SuperadminDetails(
      hasError: true,
      errorMessage: errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "company_name": companyName,
        "email": email,
        "version": firstName,
        "device_type": deviceType,
        "phone_number": phoneNumber,
      };

  SuperadminDetails copyWith({
    String? firstName,
    String? lastName,
    String? companyName,
    String? version,
    String? deviceType,
    String? email,
    String? phoneNumber,
    String? errorMessage,
  }) {
    return SuperadminDetails(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyName: companyName ?? this.companyName,
      version: version ?? this.version,
      deviceType: deviceType ?? this.deviceType,
      email: email ?? email,
      phoneNumber: phoneNumber ?? phoneNumber,
      errorMessage: errorMessage ?? errorMessage,
    );
  }
}
