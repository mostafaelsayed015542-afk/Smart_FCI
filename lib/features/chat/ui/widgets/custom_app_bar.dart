import 'package:chat_bot/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop;
        },
      ),
      title: Row(
        children: [
           SvgPicture.asset(
            'assets/svgs/blue-robot-mascot-logo-icon-design_675467-55-1-_Traced_-_1_.svg',
            height: 40.h,
            width: 24.w,
            color: AppColors.PrimaryColor,
            ),
           SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                'Smart FCI',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.PrimaryColor,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3ABF38), 
                      shape: BoxShape.circle,
                    ),
                  ),
                   SizedBox(width: 6.w),
                   Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: Color(0xFF3ABF38),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            CupertinoIcons.volume_up,
            color: Colors.black,
            size: 26,
          ),
          onPressed: () {
          },
        ),
        IconButton(
          icon: const Icon(
            CupertinoIcons.share_up,
            // Icons.file_upload_outlined, 
            color: Colors.black,
            size: 26,
          ),
          onPressed: () {
          },
        ),
         SizedBox(width: 8.w),
      ],
    );
  }


}