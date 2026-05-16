import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInput extends StatelessWidget {
  final Function(String) onSendMessage;
  final TextEditingController controller;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Write your message',
                border: InputBorder.none,
              ),
              onSubmitted: onSendMessage,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.mic,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSendMessage(controller.text.trim());
                controller.clear();
              }
            },
            icon: Icon(
              Icons.send,
              color: AppColors.PrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
