import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onOk;

  const SuccessDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onOk,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            CustomText(title: title, fontSize: 18.sp, weight: FontWeight.bold,),
            
            SizedBox(height: 2.h),

            // Message
            Text(
              message,
              style: TextStyle(fontSize: 15.sp, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),

            // Ok Button
            CustomButton(
              text: "OK",
              fontSize: 16.sp,
              textColor: Colors.white,
              onPressed: onOk,
              gradient:  LinearGradient(
                colors: [
                  AppColors.buttonColor1, 
                  AppColors.buttonColor2, 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
