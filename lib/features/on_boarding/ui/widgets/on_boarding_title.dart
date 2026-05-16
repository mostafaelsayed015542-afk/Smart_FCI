import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingTitle extends StatelessWidget {
  const OnBoardingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Your Smart FCI Assistant',
            style: TextStyle(
              color: AppColors.PrimaryColor,
              fontSize: 23.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Using this software,you can ask you \n with your lecture schedules, exam dates,\n and important college announcements \n in one place.',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
