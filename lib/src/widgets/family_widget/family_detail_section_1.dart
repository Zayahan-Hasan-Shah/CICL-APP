import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/utils/global.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FamilyDetailSection1 extends StatelessWidget {
  final String name;
  const FamilyDetailSection1({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: AppColors.buttonColor1.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: 'Family Member Name',
            weight: FontWeight.w400,
            fontSize: 16.sp,
          ),
          SizedBox(height: 1.h),
          CustomText(title: name.toTitleCase(), weight: FontWeight.bold, fontSize: 16.sp),
          Divider(color: AppColors.buttonColor1.withAlpha(77), height: 2.h),
          CustomText(
            title: 'Company Name',
            weight: FontWeight.w400,
            fontSize: 16.sp,
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: 'Century Insurance Company Ltd',
            weight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ],
      ),
    );
  }
}
