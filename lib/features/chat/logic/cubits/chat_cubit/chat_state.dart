part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatSuccess extends ChatState {
  final ChatMessageModel chatMessage;
  ChatSuccess({required this.chatMessage});
}

final class ChatFailure extends ChatState {
  final String errMsg;
  ChatFailure({required this.errMsg});
}
