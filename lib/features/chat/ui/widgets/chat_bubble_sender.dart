import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubbleSender extends StatelessWidget {
   const ChatBubbleSender({
    super.key,
   required this.text
  });
    final String text ;
  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16 ,vertical: 8),
        decoration: BoxDecoration(
            color: AppColors.PrimaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
                bottomLeft: Radius.circular(32.r))),
                
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold
            ),
        ),
      ),
    );
  }
}
