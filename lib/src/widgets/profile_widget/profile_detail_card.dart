import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';

class ProfileDetailCard extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(title: label, weight: FontWeight.w400, fontSize: 15.sp),
        SizedBox(height: 0.5.h),
        CustomText(title: value, weight: FontWeight.bold, fontSize: 15.sp),
      ],
    );
  }
}
