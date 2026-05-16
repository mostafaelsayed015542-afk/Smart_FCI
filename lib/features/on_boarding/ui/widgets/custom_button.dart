import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:chat_bot/features/chat/ui/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChatScreen(),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: AppColors.PrimaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(52.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 100.w),
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 70.w),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
