import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(1 .h),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5.h,
          ), // outer gray border
        ),
        child: Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // middle white ring
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.buttonColor1, width: 0.6.h),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // White inner circle
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),

                  // Person icon aligned near bottom but still inside
                  Align(
                    alignment: const Alignment(
                      0,
                      3.35,
                    ), // x=0 (center), y=0.7 (push down)
                    child: Icon(
                      Icons.person,
                      color: AppColors.buttonColor1,
                      size: 70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
