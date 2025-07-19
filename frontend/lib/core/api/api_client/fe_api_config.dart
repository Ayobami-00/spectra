import 'dart:io';

import 'package:dio/dio.dart';

class FeIssuingApiConfig {
  FeIssuingApiConfig(
    this.baseUrl, {
    this.bearerToken,
    Options? options,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  })  : _connectTimeout = connectTimeout ?? const Duration(milliseconds: 60000),
        _receiveTimeout = receiveTimeout ?? const Duration(milliseconds: 60000),
        _sendTimeout = sendTimeout ?? const Duration(milliseconds: 50000),
        _options = options ??
            Options(
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
            );

  Options get options => _options;

  Duration get connectionTimeout => _connectTimeout;

  Duration get receiveTimeout => _receiveTimeout;

  Duration get sendTimeout => _sendTimeout;

  final String baseUrl;
  final Options _options;

  final Duration _connectTimeout;
  final Duration _receiveTimeout;
  final Duration _sendTimeout;

  final TokenCallback? bearerToken;
}

typedef TokenCallback = Future<String> Function();
typedef ApiKeyCallback = Future<String> Function();
