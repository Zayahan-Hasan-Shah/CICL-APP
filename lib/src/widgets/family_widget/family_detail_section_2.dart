import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FamilyDetailSection2 extends StatelessWidget {
  final String relation;
  final String cnicBform;
  final String gender;
  final String dateOfBirth;

  const FamilyDetailSection2({
    super.key,
    required this.cnicBform,
    required this.relation,
    required this.gender,
    required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    final details = {
      "Relation": relation,
      "Gender": gender,
      "CNIC/B Form": cnicBform,
      "Date Of Birth": dateOfBirth,
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
