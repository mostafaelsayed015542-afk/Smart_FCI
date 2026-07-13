import 'package:chat_bot/features/chat/data/models/chat_message_model.dart';
import 'package:chat_bot/features/chat/data/repos/chat_repo.dart';
import 'package:chat_bot/features/chat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_bubble_reciever.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_bubble_sender.dart';
import 'package:chat_bot/features/chat/ui/widgets/chat_input_text_field.dart';
import 'package:chat_bot/features/chat/ui/widgets/custom_app_bar.dart';
import 'package:chat_bot/features/chat/ui/widgets/error_bubble.dart';
import 'package:chat_bot/features/chat/ui/widgets/loading_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(ChatInitial(), context.read<ChatRepo>()),
      child: const ChatScreenView(),
    );
  }
}

class ChatScreenView extends StatefulWidget {
  const ChatScreenView({super.key});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  final List<ChatMessageModel> _messages = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && !_isScrolling) {
      _isScrolling = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients && mounted) {
          _scrollController
              .animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              )
              .then((_) => _isScrolling = false);
        } else {
          _isScrolling = false;
        }
      });
    }
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessageModel(
      role: 'user',
      text: text.trim(),
      isSuccess: true,
    );

    setState(() {
      _messages.add(userMessage);
    });

    _controller.clear();
    _scrollToBottom();

    context.read<ChatCubit>().sendMessages(messages: _messages);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is ChatSuccess) {
                      setState(() {
                        _messages.add(state.chatMessage);
                      });
                      _scrollToBottom();
                    } else if (state is ChatFailure) {
                      _scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is ChatLoading;
                    final errorMessage = state is ChatFailure
                        ? state.errMsg
                        : null;

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
                      itemCount:
                          _messages.length +
                          (isLoading || errorMessage != null ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (isLoading && index == _messages.length) {
                          return loadingBubble();
                        }

                        if (errorMessage != null && index == _messages.length) {
                          return ErrorBubble(
                            errorMessage: errorMessage,

                            onPressed: () => context
                                .read<ChatCubit>()
                                .sendMessages(messages: _messages),
                          );
                        }

                        final message = _messages[index];
                        return message.isUser
                            ? ChatBubbleSender(text: message.text)
                            : ChatBubbleReciever(text: message.text);
                      },
                    );
                  },
                ),
              ),

              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: ChatInput(
                  controller: _controller,
                  onSendMessage: _handleSend,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
