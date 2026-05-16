import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 20.h,
      child: LoadingIndicator(
        indicatorType: Indicator.ballPulse, 
        colors: [Colors.grey],
        strokeWidth: 2,
      ),
    );
  }
}
