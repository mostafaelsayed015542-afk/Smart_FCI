import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/data/services/chat_api_service.dart';

/// Concrete implementation of [ChatRepo] that talks to the
/// custom ngrok/Django backend API.
///
/// Injected into [ChatCubit] via [RepositoryProvider] in main.dart.
class ChatRepoImpl extends ChatRepo {
  // Service is created here; in larger apps inject via constructor
  // for testability.
  final ChatApiService _chatApiService = ChatApiService();

  @override
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) {
    return _chatApiService.sendMessage(messages: messages);
  }
}
