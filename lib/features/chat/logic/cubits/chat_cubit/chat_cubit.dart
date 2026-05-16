import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

/// Manages the chat conversation state.
///
/// Responsibilities:
///  - Emit [ChatLoading] while the API request is in-flight.
///  - Emit [ChatSuccess] when the reply arrives.
///  - Emit [ChatFailure] on any network / parse error.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(super.initialState, this.chatRepo);

  final ChatRepo chatRepo;

  /// Sends [messages] to the backend.
  /// [messages] is the full local conversation list; the service
  /// extracts the last user message internally.
  Future<void> sendMessages({
    required List<ChatMessageModel> messages,
  }) async {
    emit(ChatLoading());
    try {
      final reply = await chatRepo.sendMessage(messages: messages);
      emit(ChatSuccess(chatMessage: reply));
    } catch (e) {
      // DioApiClient throws a plain String for network errors.
      emit(ChatFailure(errMsg: e.toString()));
    }
  }
}
