// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exceptions.freezed.dart';

@freezed
class ApiExceptions with _$ApiExceptions {
  const factory ApiExceptions.requestCancelled() = RequestCancelled;

  const factory ApiExceptions.unauthorisedRequest() = UnauthorisedRequest;

  const factory ApiExceptions.badRequest() = BadRequest;

  const factory ApiExceptions.notFound(String reason) = NotFound;

  const factory ApiExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory ApiExceptions.notAcceptable() = NotAcceptable;

  const factory ApiExceptions.requestTimeout() = RequestTimeout;

  const factory ApiExceptions.sendTimeout() = SendTimeout;

  const factory ApiExceptions.conflict() = Conflict;

  const factory ApiExceptions.internalServerError() = InternalServerError;

  const factory ApiExceptions.notImplemented() = NotImplemented;

  const factory ApiExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory ApiExceptions.noInternetConnection() = NoInternetConnection;

  const factory ApiExceptions.formatException() = FormatException;

  const factory ApiExceptions.unableToProcess() = UnableToProcess;

  const factory ApiExceptions.defaultError(String error) = DefaultError;

  const factory ApiExceptions.unexpectedError() = UnexpectedError;

  const factory ApiExceptions.serverException() = ServerError;

  const factory ApiExceptions.cacheException() = CacheError;

  const factory ApiExceptions.fireBaseAuthException(String error) =
      FireBaseAuthError;

  ///[getDioException] will be used on the reposiroty implementation.
  static ApiExceptions? getDioException(dynamic error) {
    if (error is Exception) {
      try {
        ApiExceptions? networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const ApiExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const ApiExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              networkExceptions = const ApiExceptions.noInternetConnection();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const ApiExceptions.sendTimeout();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions =
                  const ApiExceptions.unexpectedError(); // Handle as needed
              break;
            case DioExceptionType.connectionError:
              networkExceptions =
                  const ApiExceptions.unexpectedError(); // Handle as needed
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  networkExceptions = ApiExceptions.defaultError(
                    error.response!.data[''] as String,
                  );
                  break;
                case 401:
                  networkExceptions = const ApiExceptions.unauthorisedRequest();
                  break;
                case 403:
                  networkExceptions = const ApiExceptions.unauthorisedRequest();
                  break;
                case 404:
                  networkExceptions = const ApiExceptions.notFound('Not found');
                  break;
                case 409:
                  networkExceptions = const ApiExceptions.conflict();
                  break;
                case 408:
                  networkExceptions = const ApiExceptions.requestTimeout();
                  break;
                case 500:
                case 501:
                case 502:
                case 504:
                case 505:
                  networkExceptions = const ApiExceptions.internalServerError();
                  break;
                case 503:
                  networkExceptions = const ApiExceptions.serviceUnavailable();
                  break;
                default:
                  final responseCode = error.response!.statusCode;
                  networkExceptions = ApiExceptions.defaultError(
                    'Received invalid status code: $responseCode',
                  );
              }
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const ApiExceptions.sendTimeout();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const ApiExceptions.noInternetConnection();
        } else if (error is BridgecardIssuingServerException) {
          networkExceptions = const ApiExceptions.serverException();
        } else if (error is BridgecardIssuingCacheException) {
          networkExceptions = const ApiExceptions.cacheException();
        } else if (error is PlatformException) {
          networkExceptions = ApiExceptions.fireBaseAuthException(error.code);
        } else {
          networkExceptions = const ApiExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException {
        // Helper.printError(e.toString());
        return const ApiExceptions.formatException();
      } catch (_) {
        return const ApiExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains('Is not a subtype of')) {
        return const ApiExceptions.unableToProcess();
      } else {
        return const ApiExceptions.unexpectedError();
      }
    }
  }

  // ignore: lines_longer_than_80_chars
  ///[getErrormessage] will be used in the presentation layer most preferbly in the logic folder where the SM leaves in..
  static String getErrorMessage(ApiExceptions apiExceptions) {
    var errorMessage = '';
    apiExceptions.when(
      notImplemented: () {
        errorMessage = 'Not Implemented';
      },
      requestCancelled: () {
        errorMessage = 'Request Cancelled';
      },
      internalServerError: () {
        errorMessage = 'Something went wrong please try again!';
      },
      notFound: (String reason) {
        errorMessage = reason;
      },
      serviceUnavailable: () {
        errorMessage = 'Service unavailable';
      },
      methodNotAllowed: () {
        errorMessage = 'Method Allowed';
      },
      badRequest: () {
        errorMessage = 'Bad request';
      },
      unauthorisedRequest: () {
        errorMessage = 'Unauthorised request';
      },
      unexpectedError: () {
        errorMessage = 'Unexpected error occurred';
      },
      requestTimeout: () {
        errorMessage = 'Connection request timeout';
      },
      noInternetConnection: () {
        errorMessage = 'No internet connection';
      },
      conflict: () {
        errorMessage = 'Error due to a conflict';
      },
      sendTimeout: () {
        errorMessage = 'Send timeout in connection with API server';
      },
      unableToProcess: () {
        errorMessage = 'Unable to process the data';
      },
      defaultError: (String error) {
        errorMessage = error;
      },
      formatException: () {
        errorMessage = 'Unexpected error occurred';
      },
      serverException: () {
        errorMessage =
            'Unexpected error occurred trying to connect with server';
      },
      cacheException: () {
        errorMessage =
            'Unexpected error occurred trying to access local storage';
      },
      notAcceptable: () {
        errorMessage = 'Not acceptable';
      },
      fireBaseAuthException: (String error) {
        errorMessage = error;

        if (error == 'ERROR_WRONG_PASSWORD') {
          errorMessage = 'Invalid email and password combination';
        }

        if (error == 'ERROR_USER_NOT_FOUND') {
          errorMessage = 'Invalid email and password combination';
        }

        if (error == 'ERROR_EMAIL_ALREADY_IN_USE') {
          errorMessage = 'Email is already in use';
        }
      },
    );
    return errorMessage;
  }
}

class BridgecardIssuingServerException implements Exception {}

class BridgecardIssuingAnyException implements Exception {}

class BridgecardIssuingCacheException implements Exception {}

class BridgecardIssuingTimeOutException implements Exception {}
