import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/utils/global.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FamilyListWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final String relation;
  final String gender;

  const FamilyListWidget({
    super.key,
    required this.onTap,
    required this.name,
    required this.relation,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(0.5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CustomText(
              title: name.toTitleCase(),
              weight: FontWeight.bold,
              fontSize: 17.sp,
              maxLines: 1,
              alignText: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            CustomText(
              title: "Relation",
              weight: FontWeight.w800,
              fontSize: 16.sp,
            ),
            SizedBox(height: 1.h),
            CustomText(
              title: '$relation/$gender',
              weight: FontWeight.w400,
              fontSize: 16.sp,
            ),
            SizedBox(height: 2.5.h),
            _buildDetailButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailButton() {
    return CustomButton(
      text: 'Detail',
      onPressed: onTap,
      fontSize: 16.sp,
      borderRadius: 32,
      backgroundColor: AppColors.buttonColor1,
    );
  }
}
