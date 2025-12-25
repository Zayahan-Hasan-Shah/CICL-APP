import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/models/claim_model.dart/claim_limit_model.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LimitSection extends StatelessWidget {
  final UserLimitData data;
  const LimitSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.buttonColor1, width: 2),
        boxShadow: [
          BoxShadow(blurRadius: 1, color: Colors.black12, offset: Offset(2, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Limits
          CustomText(
            title: "Service Limits",
            fontSize: 16.sp,
            color: AppColors.buttonColor1,
            weight: FontWeight.w600,
          ),
          SizedBox(height: 1.h),
          ...data.limits
              .map(
                (limit) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          limit.serviceName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Limit: ${limit.dateClaimPackageLimit1}",
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          limit.hospitalDescription,
                          style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
