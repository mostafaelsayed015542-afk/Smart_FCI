// class ChatScreenView extends StatefulWidget {
//   const ChatScreenView({super.key});

//   @override
//   State<ChatScreenView> createState() => _ChatScreenViewState();
// }

// class _ChatScreenViewState extends State<ChatScreenView> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   bool _isScrolling = false; 

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients && !_isScrolling) {
//       _isScrolling = true;
      
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients && mounted) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           ).then((_) {
//             _isScrolling = false;
//           });
//         } else {
//           _isScrolling = false;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: const CustomAppBar(),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               const Divider(),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: BlocConsumer<ChatCubit, ChatState>(
//                   listenWhen: (previous, current) {
//                     return previous != current;
//                   },
//                   listener: (context, state) {
//                     if (state is ChatSuccess || state is ChatLoading) {
//                       _scrollToBottom();
//                     }
//                   },
//                   buildWhen: (previous, current) {
//                     return previous != current;
//                   },
//                   builder: (context, state) {
//                     List<MessageModel> messages = [];
//                     bool isLoading = false;

//                     if (state is ChatLoading) {
//                       messages = state.messages;
//                       isLoading = true;
//                     } else if (state is ChatSuccess) {
//                       messages = state.messages;
//                     } else if (state is ChatFailure) {
//                       messages = state.messages;
//                     }

//                     return ListView.builder(
//                       controller: _scrollController,
//                       padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
//                       itemCount: messages.length + (isLoading ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (isLoading && index == messages.length) {
//                           return Padding(
//                             padding: EdgeInsets.only(bottom: 16.h),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20.w,
//                                     vertical: 14.h,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.chatBubbleRecieverColor,
//                                     borderRadius: BorderRadius.circular(12.r),
//                                   ),
//                                   child: const TypingIndicator(),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }

//                         final message = messages[index];
//                         return message.isUser
//                             ? ChatBubbleSender(
//                                 key: ValueKey('sender_$index'),
//                                 text: message.text,
//                               )
//                             : ChatBubbleReciever(
//                                 key: ValueKey('receiver_$index'),
//                                 text: message.text,
//                               );
//                       },
//                     );
//                   },
//                 ),
//               ),
//               Positioned(
//                 left: 16.w,
//                 right: 16.w,
//                 bottom: 16.h,
//                 child: ChatInput(
//                   controller: _controller,
//                   onSendMessage: (text) {
//                     if (text.trim().isNotEmpty) {
//                       context.read<ChatCubit>().sendMessage(text);
//                       _controller.clear();
//                      // FocusScope.of(context).unfocus(); 
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }