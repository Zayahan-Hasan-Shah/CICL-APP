import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:cicl_app/src/models/claim_model.dart/claim_limit_model.dart';
import 'package:sizer/sizer.dart';

class OpdLimitSection extends StatelessWidget {
  final UserLimitData data;
  const OpdLimitSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Get OPD Claims
    final opdClaims = data.opdClaims;

    // Get OPD Limits (serviceName contains 'OPD')
    final opdLimits = data.limits
        .where((item) => item.serviceName.toUpperCase().contains('OPD'))
        .toList();

    // Sum of OPD limits
    final totalOpdLimit = opdLimits.fold<num>(
      0,
      (sum, item) => sum + (item.dateClaimPackageLimit1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (opdLimits.isNotEmpty)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 2.h),
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
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor1.withAlpha(40),
                  ),
                  children: [
                    _cell('Service Name', isHeader: true),
                    _cell('Limit', isHeader: true),
                  ],
                ),
                for (var item in opdLimits)
                  TableRow(
                    children: [
                      _cell(item.serviceName),
                      _cell(item.dateClaimPackageLimit1.toString()),
                    ],
                  ),
                // Total row
                TableRow(
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor1.withAlpha(30),
                  ),
                  children: [
                    _cell('Total OPD Limit', isHeader: true),
                    _cell(
                      AppValidation().formatAmount(totalOpdLimit),
                      isHeader: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (opdClaims.isEmpty) const Center(child: Text("No OPD claims found")),
        if (opdClaims.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.buttonColor1),
              ),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.blue.shade50,
                ),
                border: TableBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  horizontalInside: BorderSide(
                    color: AppColors.buttonColor1.withOpacity(0.5),
                    width: 1,
                  ),
                  verticalInside: BorderSide(
                    color: AppColors.buttonColor1.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                columns: [
                  _dataColumn('ClaimNo'),
                  _dataColumn('Bill Date'),
                  _dataColumn('Bill Amount'),
                  _dataColumn('Approved'),
                  _dataColumn('Deduction'),
                  _dataColumn('Employee No'),
                  _dataColumn('CL CIC Emp No'),
                  _dataColumn('Col Code'),
                  _dataColumn('Report Date'),
                  _dataColumn('GL Voucher No'),
                  _dataColumn('Loss Date'),
                  _dataColumn('Col Name'),
                  _dataColumn('Service Type'),
                ],
                rows: opdClaims.map((claim) => _buildClaimRow(claim)).toList(),
              ),
            ),
          ),
      ],
    );
  }

  DataColumn _dataColumn(String title) {
    return DataColumn(
      label: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: CustomText(
          title: title,
          fontSize: 15.sp,
          color: AppColors.buttonColor1,
          weight: FontWeight.bold,
        ),
      ),
    );
  }

  DataRow _buildClaimRow(OPDClaims claim) {
    return DataRow(
      cells: [
        _dataCell(claim.clmseqnos.toString()),
        _dataCell(claim.lossdate),
        _dataCell(AppValidation().formatAmount(num.parse(claim.bill_amount))),
        _dataCell(AppValidation().formatAmount(num.parse(claim.approved))),
        _dataCell(claim.deduction ?? 'N/A'),
        _dataCell(claim.employee_no),
        _dataCell(claim.cl_cicempno),
        _dataCell(claim.colcode.toString()),
        _dataCell(claim.reportdate),
        _dataCell(claim.glvoucherno),
        _dataCell(claim.lossdate),
        _dataCell(claim.colname),
        _dataCell('Out Patient'),
      ],
    );
  }

  DataCell _dataCell(String text) {
    return DataCell(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87, fontSize: 15.sp),
        ),
      ),
    );
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
