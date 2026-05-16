import 'package:chat_bot/features/chat/ui/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class loadingBubble extends StatelessWidget {
  const loadingBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const TypingIndicator(),
          ),
        ],
      ),
    );
  }
}