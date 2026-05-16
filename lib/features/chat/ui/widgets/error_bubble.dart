import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorBubble extends StatelessWidget {
  const ErrorBubble({
    super.key,
    required this.errorMessage, this.onPressed,
  });

  final String? errorMessage;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.red.shade300,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed:onPressed,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}