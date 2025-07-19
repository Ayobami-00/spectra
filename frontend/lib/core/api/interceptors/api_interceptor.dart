import 'package:frontend/core/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

Future<ApiResult<T>> apiInterceptor<T>(
  Future<T> future,
) async {
  final internetConnectionInfo = locator<InternetConnection>();

  if (!await internetConnectionInfo.isDeviceConnected) {
    return const ApiResult.apiFailure(
      error: ApiExceptions.noInternetConnection(),
    );
  }

  try {
    final result = await future;
    return ApiResult.success(data: result);
  } on DioException catch (exception) {
    return onDioError(
      exception,
      [
        // We ignore this status code because it is the default response from the [LinkingDataSource.onebridgeBankAuth] endpoint
        // and we require this status code to pass through our [apiInterceptor] as the error is properly handled on the UI layer.
        451,
      ],
    );
  } on PlatformException catch (e) {
    return ApiResult.apiFailure(
      error: ApiExceptions.fireBaseAuthException(e.code),
    );
  } catch (_) {
    return const ApiResult.apiFailure(
      error: ApiExceptions.defaultError(
        'An internal error occurred. Please try again later',
      ),
    );
  }
}

ApiResult<T> onDioError<T>(
  DioException exception,
  List<int> ignore,
) {
  if (exception.response == null || exception.response?.data == null) {
    return ApiResult.apiFailure(
      error: ApiExceptions.getDioException(exception)!,
    );
  }
  final response = exception.response!;
  final statusCode = response.statusCode ?? -2;

  // Don't report if status code is part of the ignored list
  if (ignore.contains(statusCode)) {
    // if (statusCode == 451) {
    //   return ApiResult.success(
    //     data: OnebridgeMobileLoginResponse.fromJson(
    //       response.data as Map<String, dynamic>,
    //     ) as T,
    //   );
    // }
    ApplicationErrorLogger.log(
      exception,
      StackTrace.current,
      moreInfo: {
        'response': response.data,
        'request': {
          'path': exception.requestOptions.path,
          'data': exception.requestOptions.data,
        }
      },
    );
  }

  final res = response.data;
  String? error;

  // possible error models that the api can return
  final errorModels = [
    'message',
    'error',
    'error.message',
    'data.message',
    'error.data.message'
  ];

  if (res is Map) {
    // Try to find the first message that matches the error model
    for (int i = 0; i < errorModels.length; i++) {
      error = _extractMessage(res, errorModels[i]);

      if (error != null) break; // Found our error message: Break loop
    }
  }

  if (error != null) {
    return ApiResult.apiFailure(
      error: ApiExceptions.defaultError(error),
      statusCode: statusCode,
    );
  }

  return ApiResult.apiFailure(
    error: ApiExceptions.getDioException(exception)!,
    statusCode: statusCode,
  );
}

String? _extractMessage(Map data, String model) {
  final models = model.split('.');

  Map? extracted = data;
  try {
    for (int i = 0; i < models.length; i++) {
      final element = models[i];
      if (extracted![element] is String) return extracted[element] as String?;

      extracted = extracted[element] as Map<dynamic, dynamic>?;
    }
  } catch (e) {
    return null;
  }

  return null;
}
