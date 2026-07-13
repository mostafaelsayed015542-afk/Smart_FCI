import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';

abstract class ChatRepo {
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  });
}
