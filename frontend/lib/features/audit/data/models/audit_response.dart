import 'dart:convert';

import 'package:frontend/features/audit/data/index.dart';

import 'data.dart';

class AuditResponse {
  final String? status;
  final String? message;
  final Data? data;
  final bool hasError;

  AuditResponse({this.hasError = false, this.status, this.message, this.data});

  @override
  String toString() {
    return 'AuditResponse(status: $status, message: $message, data: $data)';
  }

  factory AuditResponse.fromMap(Map<String, dynamic> data) {
    return AuditResponse(
      status: data['status'] as String?,
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AuditResponse].
  factory AuditResponse.fromJson(String data) {
    return AuditResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  factory AuditResponse.hasError(String errorMessage) => AuditResponse(
        status: "failed",
        message: errorMessage,
        hasError: true,
      );

  factory AuditResponse.initial() => AuditResponse(
        status: "initial",
        message: "",
      );

  /// `dart:convert`
  ///
  /// Converts [AuditResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  AuditResponse copyWith({
    String? status,
    String? message,
    Data? data,
  }) {
    return AuditResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
