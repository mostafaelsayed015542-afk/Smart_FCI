















































// import 'dart:convert';
// import 'package:chat_bot/features/chat/data/models/gemini_model.dart';
// import 'package:dio/dio.dart';
// import 'package:chat_bot/core/constants/app_constants.dart';

// class GeminiChatService {
//   final Dio _dio = Dio();

//   Future<String> sendMessage(String message) async {
//     final url = AppConstants.baseUrl;

//     try {
//       final response = await _dio.post(
//         url,
//         data: {
//           "contents": [
//             {
//               "parts": [
//                 {"text": message}
//               ]
//             }
//           ]
//         },
//         options: Options(
//           headers: {
//             "Content-Type": "application/json",
//           },
//           responseType: ResponseType.json,
//         ),
//       );
//       final geminiResponse = GeminiModel.fromJson(response.data);
      
//       if (!geminiResponse.isSuccess) {
//         throw Exception(geminiResponse.text);
//       }
      
//       return geminiResponse.text;
      
//     } catch (e) {
//       throw Exception("Gemini error: $e");
//     }
//   }
// }

























// import 'package:dio/dio.dart';
// import 'package:chat_bot/core/constants/app_constants.dart';

// class GeminiRepository {
//   final Dio _dio = Dio();

//   Future<String> sendMessage(String message) async {
//     final url = AppConstants.baseUrl;
//     try {
//       final response = await _dio.post(
//         url,
//         data: {
//           "contents": [
//             {
//               "parts": [
//                 {"text": message},
//               ],
//             },
//           ],
//         },
//         options: Options(
//           headers: {"Content-Type": "application/json"},
//           responseType: ResponseType.plain
//         ),
//       );

//       print("Gemini API Response Status: ${response.statusCode}");
//       // response.data can be Map or String depending on Dio configuration/headers
//       print("Gemini API Response Type: ${response.data.runtimeType}");

//       dynamic responseData = response.data;

//       // If response.data is a String, we must parse it
//       if (responseData is String) {
//         // We need 'dart:convert' for jsonDecode, but it might not be imported.
//         // As a quick fix, usually Dio parses JSON.
//         // If it's a string, it means headers were weird.
//         // But let's assume valid JSON loop or similar.
//       }

//       // Accessing with safe casts
//       final Map<String, dynamic> data = responseData is Map<String, dynamic>
//           ? responseData
//           : (responseData is Map
//                 ? Map<String, dynamic>.from(responseData)
//                 : {});

//       if (data.isEmpty) {
//         // Try to interpret as List or String to debug
//         print("Response data is not a Map: $responseData");
//         throw Exception("Invalid response format: ${responseData.runtimeType}");
//       }

//       if (response.statusCode == 200) {
//         if (data.containsKey('candidates')) {
//           final candidates = data['candidates'];
//           if (candidates is List && candidates.isNotEmpty) {
//             final firstCandidate = candidates[0];
//             if (firstCandidate is Map &&
//                 firstCandidate.containsKey('content')) {
//               final content = firstCandidate['content'];
//               if (content is Map && content.containsKey('parts')) {
//                 final parts = content['parts'];
//                 if (parts is List && parts.isNotEmpty) {
//                   final firstPart = parts[0];
//                   if (firstPart is Map && firstPart.containsKey('text')) {
//                     return firstPart['text'].toString();
//                   } else if (firstPart is String) {
//                     // Handle case where parts might be simple strings (unlikely for Gemini but possible in error)
//                     return firstPart;
//                   }
//                 }
//               }
//             }
//           }
//         }

//         print("Unexpected response structure: $data");
//         if (data['promptFeedback'] != null) {
//           print("Prompt Feedback: ${data['promptFeedback']}");
//           return "Response blocked by safety settings.";
//         }
//         return "I couldn't understand the response.";
//       } else {
//         throw Exception('Failed to load response: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Gemini Repository Error: $e");
//       throw Exception('Gemini error: $e');
//     }
//   }
// }























// Future<void> streamMessage(
//   String message, {
//   required Function(String chunk) onData,
// }) async {
//   final dio = Dio();

//   final url =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:streamGenerateContent'
//       '?key=${AppConstants.geminiAPiKey}';

//   final response = await dio.post(
//     url,
//     data: {
//       "contents": [
//         {
//           "parts": [
//             {"text": message}
//           ]
//         }
//       ]
//     },
//     options: Options(
//       responseType: ResponseType.stream,
//       headers: {
//         "Content-Type": "application/json",
//       },
//     ),
//   );

//   response.data.stream.listen((event) {
//     final chunk = String.fromCharCodes(event);
//     onData(chunk);
//   });
// }

// import 'package:chat_bot/core/constants/app_constants.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiRepository {
//   late final GenerativeModel _model;

//   GeminiRepository({required String apiKey}) {
//     _model = GenerativeModel(
//      model: 'gemini-1.5-flash', // gemini-1.5-flash might not be available yet
//       apiKey: apiKey,
//     );
//   }

//   // إرسال رسالة والحصول على رد
//   Future<String> sendMessage(String message) async {
//     try {
//       final content = [Content.text(message)];
//       final response = await _model.generateContent(content);

//       return response.text ?? 'عذراً، لم أستطع الرد';
//     } catch (e) {
//       throw Exception('فشل في الاتصال بـ Gemini: ${e.toString()}');
//     }
//   }

//   // للمحادثات المتعددة (مع تاريخ)
//   Future<String> sendMessageWithHistory({
//     required String message,
//     required List<Map<String, dynamic>> history,
//   }) async {
//     try {
//       // تحويل التاريخ لـ Content objects
//       final chatHistory = history.map((msg) {
//         return Content.text(msg['message'] as String);
//       }).toList();

//       // بدء محادثة
//       final chat = _model.startChat(history: chatHistory);

//       // إرسال الرسالة الجديدة
//       final response = await chat.sendMessage(Content.text(message));

//       return response.text ?? 'عذراً، لم أستطع الرد';
//     } catch (e) {
//       throw Exception('فشل في الاتصال بـ Gemini: ${e.toString()}');
//     }
//   }
// }
