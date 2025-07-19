import 'dart:io';
import 'package:frontend/core/api/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FeApiClient {
  FeApiClient(this._apiConfig);

  final FeIssuingApiConfig _apiConfig;

  Dio omDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: _apiConfig.baseUrl,
        // connectTimeout: _apiConfig.connectionTimeout,
        // receiveTimeout: _apiConfig.receiveTimeout,
        // sendTimeout: _apiConfig.sendTimeout,
        headers: _apiConfig.options.headers,
      ),
    );
    /* if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors);
    } */
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    // Firebase Performance Interceptor
    // final performanceInterceptor = DioFirebasePerformanceInterceptor();
    // dio.interceptors.add(performanceInterceptor);
    return dio;
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
  }) async {
    Response response;
    try {
      response = await omDio().get(
        url,
        queryParameters: queryParameters,
        options: await _getOptions(headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<Response> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
  }) async {
    Response response;
    try {
      response = await omDio().post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: await _getOptions(headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<Response> put(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
  }) async {
    Response response;
    try {
      response = await omDio().put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: await _getOptions(headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<Response> patch(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
  }) async {
    Response response;
    try {
      response = await omDio().patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: await _getOptions(headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<Response> delete(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
  }) async {
    Response response;
    try {
      response = await omDio().delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: await _getOptions(headers),
        cancelToken: cancelToken,
      );
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<Options> _getOptions(Map<String, dynamic>? customHeaders) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (customHeaders != null) ...customHeaders,
    };

    if (_apiConfig.bearerToken != null && customHeaders?.keys == null) {
      final token = await _apiConfig.bearerToken!();
      if (token.isNotEmpty) {
        headers["token"] = "Bearer $token";
        headers["ngrok-skip-browser-warning"] = "ess";
      }
    }

    return Options(
      headers: headers,
    );
  }
}
