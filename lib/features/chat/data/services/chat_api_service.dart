import 'dart:convert'; // jsonEncode — guarantees UTF-8 output for Arabic text

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';

class ChatApiService {
  static const String _fullApiUrl =
      'https://soaplike-uncalcined-delicia.ngrok-free.dev/api/chat/post/';

  late final Dio _dio;

  ChatApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json; charset=utf-8',
        headers: {
          'Accept': 'application/json',

          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('──────────────────────────────────────');
            print('REQUEST  [${options.method}] ${options.uri}');
            print('BODY     : ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE [${response.statusCode}]');
            print('DATA     : ${response.data}');
            print('──────────────────────────────────────');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('ERROR    [${e.response?.statusCode}] ${e.message}');
            print('──────────────────────────────────────');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) async {
    final userMessages = messages.where((m) => m.isUser).toList();
    if (userMessages.isEmpty) {
      return const ChatMessageModel(
        text: 'No user message found to send.',
        role: 'model',
        isSuccess: false,
      );
    }
    final lastUserMessage = userMessages.last;

    final String encodedBody = jsonEncode(lastUserMessage.toRequestJson());

    try {
      final response = await _dio.post<dynamic>(
        _fullApiUrl,
        data: encodedBody,
        options: Options(
          contentType: 'application/json; charset=utf-8',
          responseType: ResponseType.json,
        ),
      );

      final dynamic responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        return ChatMessageModel.fromJson(responseData);
      }

      if (responseData is String && responseData.isNotEmpty) {
        try {
          final decoded = jsonDecode(responseData) as Map<String, dynamic>;
          return ChatMessageModel.fromJson(decoded);
        } catch (_) {
          return ChatMessageModel(
            text: responseData,
            role: 'model',
            isSuccess: true,
          );
        }
      }

      return const ChatMessageModel(
        text: 'Unexpected response format from server.',
        role: 'model',
        isSuccess: false,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw 'Unexpected error: ${e.toString()}';
    }
  }

  String _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request send timed out. Try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond. Try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  String _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request (400). Check the prompt format.';
      case 401:
        return 'Unauthorized (401).';
      case 403:
        return 'Access forbidden (403).';
      case 404:
        return 'API endpoint not found (404).';
      case 422:
        return 'Validation error (422). The server rejected the request body.';
      case 500:
        return 'Internal server error (500). Try again later.';
      case 502:
        return 'Bad gateway (502). The server is temporarily unavailable.';
      case 503:
        return 'Service unavailable (503). Try again later.';
      default:
        return 'Server error (HTTP $statusCode).';
    }
  }
}
