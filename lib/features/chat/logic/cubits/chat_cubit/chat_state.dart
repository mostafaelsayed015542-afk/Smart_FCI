part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

/// Initial state — no messages yet.
final class ChatInitial extends ChatState {}

/// API request is in-flight.
final class ChatLoading extends ChatState {}

/// API returned a valid reply.
final class ChatSuccess extends ChatState {
  final ChatMessageModel chatMessage;
  ChatSuccess({required this.chatMessage});
}

/// Network or server error occurred.
final class ChatFailure extends ChatState {
  final String errMsg;
  ChatFailure({required this.errMsg});
}
