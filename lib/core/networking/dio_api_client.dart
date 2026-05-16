import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioApiClient {
  late Dio _dio;
  final String baseUrl;

  DioApiClient({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Required to bypass ngrok's browser-warning interstitial page.
          // Without this, ngrok returns an HTML page instead of JSON.
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('DATA: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            print('DATA: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            print('MESSAGE: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }
// POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  // Error Handler
  String _handleError(DioException error) {
    String errorMessage = '';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection';
        break;
      default:
        errorMessage = 'Something went wrong';
    }
    
    return errorMessage;
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Error: $statusCode';
    }
  }
}