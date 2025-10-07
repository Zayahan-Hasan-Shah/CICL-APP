import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/models/claim_model.dart/claim_limit_model.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HospitalizationLimitSection extends StatelessWidget {
  final UserLimitData data;
  const HospitalizationLimitSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Filter Hospitalization-related limits
    final hospLimits = data.limits
        .where(
          (item) =>
              item.serviceName.toUpperCase().contains('HOSPITALIZATION') ||
              item.serviceName.toUpperCase().contains('DELIVERY'),
        )
        .toList();

    // Get IPD Claims
    final ipdClaims = data.ipdClaims;

    if (hospLimits.isEmpty) {
      return const Center(child: Text("No Hospitalization limits found"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Limits Section
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(color: AppColors.buttonColor1.withAlpha(77)),
          ),
          child: Table(
            border: TableBorder.all(
              color: AppColors.buttonColor1.withAlpha(60),
            ),
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
            children: [
              _buildHeader("Service Name", "Limit"),
              for (var item in hospLimits)
                _buildRow(
                  item.serviceName,
                  item.dateClaimPackageLimit1.toString(),
                ),
            ],
          ),
        ),

        // Claims Section
        if (ipdClaims.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: CustomText(
              title: "IPD Claims",
              fontSize: 16.sp,
              weight: FontWeight.bold,
              color: AppColors.buttonColor1,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.buttonColor1.withAlpha(77)),
            ),
            child: Table(
              border: TableBorder.all(
                color: AppColors.buttonColor1.withAlpha(60),
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              children: [
                _buildHeader("Bill Amount", "Approved"),
                for (var claim in ipdClaims)
                  _buildRow(claim.billAmount ?? 'N/A', claim.approved ?? 'N/A'),
              ],
            ),
          ),
        ],
      ],
    );
  }

  TableRow _buildHeader(String col1, String col2) {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.buttonColor1.withAlpha(40)),
      children: [_cell(col1, isHeader: true), _cell(col2, isHeader: true)],
    );
  }

  TableRow _buildRow(String name, String limit) {
    return TableRow(children: [_cell(name), _cell(limit)]);
  }

  Widget _cell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(1.5.h),
      child: CustomText(
        title: text,
        fontSize: 14.sp,
        weight: isHeader ? FontWeight.bold : FontWeight.w500,
        color: isHeader ? AppColors.buttonColor1 : Colors.black,
      ),
    );
  }
}
