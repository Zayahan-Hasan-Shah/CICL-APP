import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// import 'claim_calendar_filter.dart';

class ClaimSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(DateTime?, DateTime?) onDateRangeSelected;

  const ClaimSearchBar({
    super.key,
    required this.controller,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: CustomTextField(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
          size: 30,
        ),
        controller: controller,
        borderColor: AppColors.brightYellowColor,
        hintText: 'Search...',
        // suffixIcon: IconButton(
        //   icon: const Icon(Icons.calendar_month_outlined,
        //       color: AppColors.purpleColor),
        //   onPressed: () => showCalendarFilter(context, onDateRangeSelected),
        // ),
      ),
    );
  }
}
