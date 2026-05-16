import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubbleReciever extends StatelessWidget {
   const ChatBubbleReciever({
    super.key,
     required this.text,
    
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16.w ,vertical: 8.h),
        decoration: BoxDecoration(
            color: AppColors.chatBubbleRecieverColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
                bottomRight: Radius.circular(32.r))),
                
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400
            ),
        ),
      ),
    );
  }
}