import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ClaimEntriesInfo extends StatelessWidget {
  final int start;
  final int? end;
  final int total;

  const ClaimEntriesInfo({
    super.key,
    required this.start,
    this.end,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 4.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title: '$start of $total ',
            weight: FontWeight.w500,
          ),
          Row(
            children: [
              const Icon(Icons.add_circle, color: AppColors.buttonColor1),
              TextButton(
                onPressed: () {
                  context.push('/addclaimscreen');
                },
                child: Text(
                  'Add Claims',
                  style: TextStyle(
                    color: AppColors.buttonColor1,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
