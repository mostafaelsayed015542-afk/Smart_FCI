import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(super.initialState, this.chatRepo);

  final ChatRepo chatRepo;

  Future<void> sendMessages({required List<ChatMessageModel> messages}) async {
    emit(ChatLoading());
    try {
      final reply = await chatRepo.sendMessage(messages: messages);
      emit(ChatSuccess(chatMessage: reply));
    } catch (e) {
      emit(ChatFailure(errMsg: e.toString()));
    }
  }
}
