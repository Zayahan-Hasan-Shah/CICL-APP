import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ClaimListWidget extends StatelessWidget {
  final VoidCallback onTap;
  final int srvCode;
  final String clmsEqnos;
  final String cuserId;
  final int billAmount;
  final String reportDate;
  final int deductAmount;
  final int approveAmount;

  const ClaimListWidget({
    super.key,
    required this.onTap,
    required this.srvCode,
    required this.clmsEqnos,
    required this.cuserId,
    required this.billAmount,
    required this.reportDate,
    required this.deductAmount,
    required this.approveAmount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.whiteColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildText("Claim#$clmsEqnos", fontSize: 18.sp),
            _buildText(
                DateFormat('dd-MMM-yyyy').format(DateTime.parse(reportDate)),
                weight: FontWeight.w400),
            _buildAmount(AppValidation().formatAmount(billAmount)),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, {double? fontSize, FontWeight? weight}) {
    return CustomText(
      title: text,
      fontSize: fontSize ?? 16.sp,
      weight: weight ?? FontWeight.w600,
    );
  }

  Widget _buildAmount(String billAmot) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
          color: AppColors.buttonColor1,
          borderRadius: BorderRadius.circular(16)),
      child: CustomText(
        title: 'Rs.$billAmot',
        fontSize: 16.sp,
        color: AppColors.whiteColor,
      ),
    );
  }

}
