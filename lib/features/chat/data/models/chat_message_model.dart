import 'dart:convert';

class ChatMessageModel {
  final String text;

  final String role;

  final bool isSuccess;

  const ChatMessageModel({
    required this.text,
    required this.role,
    required this.isSuccess,
  });

  bool get isUser => role == 'user';
  bool get isModel => role == 'model';

  Map<String, dynamic> toRequestJson() => {'prompt': text};

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    try {
      final errorText = json['error'] ?? json['detail'];
      if (errorText != null) {
        return ChatMessageModel(
          text: errorText.toString(),
          role: 'model',
          isSuccess: false,
        );
      }

      final replyText =
          json['response'] ??
          json['reply'] ??
          json['answer'] ??
          json['message'] ??
          json['text'];

      if (replyText != null) {
        return ChatMessageModel(
          text: replyText.toString(),
          role: 'model',
          isSuccess: true,
        );
      }

      return ChatMessageModel(
        text: 'Unexpected response format. Raw: ${jsonEncode(json)}',
        role: 'model',
        isSuccess: false,
      );
    } catch (_) {
      return const ChatMessageModel(
        text: 'Failed to parse server response.',
        role: 'model',
        isSuccess: false,
      );
    }
  }

  @override
  String toString() =>
      'ChatMessageModel(role: $role, isSuccess: $isSuccess, text: $text)';
}
