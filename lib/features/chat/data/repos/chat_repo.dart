import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';

/// Abstract contract for the chat repository.
/// Any implementation (real API, mock, etc.) must satisfy this interface.
abstract class ChatRepo {
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  });
}