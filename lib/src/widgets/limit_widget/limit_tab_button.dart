import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LimitTabButton extends StatelessWidget {
  final String title;
  final int index;
  final int selectedTab;
  final ValueChanged<int> onTap;
  const LimitTabButton({
    super.key,
    required this.title,
    required this.index,
    required this.selectedTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(microseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonColor1 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.buttonColor1, width: 0.4.w),
        ),
        child: CustomText(
          title: title,
          color: isSelected ? Colors.white : AppColors.buttonColor1,
          fontSize: 15.sp,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}
