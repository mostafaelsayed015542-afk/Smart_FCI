import 'dart:convert'; // jsonEncode — guarantees UTF-8 output for Arabic text

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';

// ============================================================
// ChatApiService
// ============================================================
// Single responsibility: POST the user's prompt to the backend
// and return a parsed ChatMessageModel.
//
// Full API URL (used directly — no base/path split):
//   https://soaplike-uncalcined-delicia.ngrok-free.dev/api/chat/post/
//
// Request:
//   Method  : POST
//   Headers : Content-Type: application/json; charset=utf-8
//             Accept: application/json
//             ngrok-skip-browser-warning: true
//   Body    : { "prompt": "<user question>" }
//
// Response (success):
//   { "response": "..." }  OR  { "reply": "..." }  (parsed by model)
//
// Response (error):
//   { "error": "..." }  OR  { "detail": "..." }   (parsed by model)
//
// Example Arabic request body:
//   jsonEncode({"prompt": "عندنا محاضرات اي يوم الاربعاء؟"})
//   → '{"prompt":"عندنا محاضرات اي يوم الاربعاء؟"}'
// ============================================================

class ChatApiService {
  // ── Full API URL (not split into baseUrl + path) ──────────────
  // Using the absolute URL directly as required by the API spec.
  static const String _fullApiUrl =
      'https://soaplike-uncalcined-delicia.ngrok-free.dev/api/chat/post/';

  // ── Dio instance ──────────────────────────────────────────────
  // Configured once and reused. No baseUrl is set on the instance
  // because we pass the full URL to every request.
  late final Dio _dio;

  ChatApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        // "application/json; charset=utf-8" ensures the server interprets
        // the body as UTF-8 encoded JSON — critical for Arabic text.
        contentType: 'application/json; charset=utf-8',
        headers: {
          'Accept': 'application/json',
          // Bypass ngrok's browser-warning HTML interstitial.
          // Without this header, ngrok returns an HTML page, not JSON.
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );

    // Debug logger — prints every request/response/error in debug mode
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

  // ─────────────────────────────────────────────────────────────
  // sendMessage
  // ─────────────────────────────────────────────────────────────
  /// Extracts the last user message from [messages], encodes it as
  /// `{ "prompt": "..." }`, POSTs to the API, and returns the reply.
  ///
  /// Throws a descriptive [String] on network/timeout/server errors.
  /// The caller (ChatCubit) catches this and emits [ChatFailure].
  ///
  /// Example request body for Arabic input:
  ///   '{"prompt":"عندنا محاضرات اي يوم الاربعاء؟"}'
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) async {
    // ── 1. Extract the last user message ──────────────────────
    final userMessages = messages.where((m) => m.isUser).toList();
    if (userMessages.isEmpty) {
      return const ChatMessageModel(
        text: 'No user message found to send.',
        role: 'model',
        isSuccess: false,
      );
    }
    final lastUserMessage = userMessages.last;

    // ── 2. Build request body ─────────────────────────────────
    // jsonEncode produces a UTF-8 encoded JSON string.
    // The key MUST be "prompt" per the API specification.
    //
    // Arabic example:
    //   userMessage = "ما هو أفضل مطعم في القاهرة؟"
    //   encoded     = '{"prompt":"ما هو أفضل مطعم في القاهرة؟"}'
    final String encodedBody = jsonEncode(
      lastUserMessage.toRequestJson(), // → { "prompt": "<text>" }
    );

    try {
      // ── 3. POST to the full API URL ───────────────────────────
      // Use post<dynamic> so response.data stays typed as dynamic.
      // This allows the String fallback branch below to be reachable
      // (if the server sends a non-JSON text body).
      final response = await _dio.post<dynamic>(
        _fullApiUrl,
        // Pass the pre-encoded string so Dio does NOT double-encode it.
        data: encodedBody,
        options: Options(
          // "charset=utf-8" tells the server the body is UTF-8 encoded,
          // which is required for correct Arabic character transmission.
          contentType: 'application/json; charset=utf-8',
          // Tell Dio the response is JSON so it auto-decodes to Map.
          responseType: ResponseType.json,
        ),
      );

      // ── 4. Parse response ──────────────────────────────────────
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
        // Covers SocketException (no internet, DNS failure, etc.)
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
