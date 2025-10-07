import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ClaimPagination extends StatelessWidget {
  final int pageNo;
  final int total;
  final int pageSize;
  final void Function(int newPage) onPageChanged;

  const ClaimPagination({
    super.key,
    required this.pageNo,
    required this.total,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ⬅️ Prev
          OutlinedButton(
            style: _buttonStyle,
            onPressed: pageNo > 0 ? () => onPageChanged(pageNo - 1) : null,
            child: const Icon(Icons.arrow_back, color: AppColors.purpleColor),
          ),
          SizedBox(width: 3.w),
          // 📄 Page info
          CustomText(
            title: 'Page ${pageNo + 1} of ${(total / pageSize).ceil()}',
            fontSize: 14.sp,
            weight: FontWeight.w500,
          ),
          SizedBox(width: 3.w),
          // ➡️ Next
          OutlinedButton(
            style: _buttonStyle,
            onPressed: (pageNo + 1) * pageSize < total
                ? () => onPageChanged(pageNo + 1)
                : null,
            child:
                const Icon(Icons.arrow_forward, color: AppColors.purpleColor),
          ),
        ],
      ),
    );
  }

  ButtonStyle get _buttonStyle => OutlinedButton.styleFrom(
        side: const BorderSide(
          color: AppColors.brightYellowColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      );
}
