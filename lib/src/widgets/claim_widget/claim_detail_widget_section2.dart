import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/utils/global.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ClaimDetailWidgetSection2 extends StatelessWidget {
  final String billNumber;
  final String billDate;
  final String? admitdt;
  final String? dischargdt;
  final int serviceCode;
  final String serviceName;
  final double approveAmount;
  final double deductAmount;
  final String dob;
  final String relation;
  final String empno;
  final String patientName;
  final String pateintCNIC;

  const ClaimDetailWidgetSection2({
    super.key,
    required this.billNumber,
    required this.billDate,
    required this.admitdt,
    required this.dischargdt,
    required this.serviceCode,
    required this.serviceName,
    required this.approveAmount,
    required this.deductAmount,
    required this.dob,
    required this.relation,
    required this.empno,
    required this.patientName,
    required this.pateintCNIC,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return "N/A";
      try {
        final date = DateTime.parse(dateStr);
        return DateFormat('dd MMM, yyyy').format(date);
      } catch (e) {
        return "N/A";
      }
    }

    final details = {
      "Bill Date": billDate.isEmpty
          ? ""
          : DateFormat('dd MMM, yyyy').format(DateTime.parse(billDate)),
      "Employee Number": empno.isEmpty ? "" : empno,
      "Benefit Type": serviceName,
      "Amount Claimed": AppValidation().formatAmount(
        approveAmount + deductAmount,
      ),
      "Amount Deducted": AppValidation().formatAmount(deductAmount),
      "Amount Approved": AppValidation().formatAmount(approveAmount),
      "Patient Name": patientName.isEmpty ? "" : patientName.toTitleCase(),
      "Admission Date": formatDate(admitdt),
      "Discharge Date": formatDate(dischargdt),
    };
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.5,
          color: AppColors.buttonColor1.withAlpha(77),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < details.length; i++)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.8.h),
              decoration: BoxDecoration(
                color: i.isEven
                    ? AppColors
                          .bgFamDetailColor // light gray background
                    : AppColors.whiteColor, // white background
                borderRadius: i == 0
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      )
                    : i == details.length - 1
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )
                    : BorderRadius.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: details.keys.elementAt(i),
                    weight: FontWeight.w600,
                  ),
                  Flexible(
                    child: CustomText(
                      title: details.values.elementAt(i),
                      weight: FontWeight.w600,
                      alignText: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
