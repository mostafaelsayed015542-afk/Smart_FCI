import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/services/chat_api_service.dart';

class ChatRepoImpl extends ChatRepo {
  final ChatApiService _chatApiService = ChatApiService();

  @override
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) {
    return _chatApiService.sendMessage(messages: messages);
  }
}
