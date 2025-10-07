import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/models/profile_model/card_detail_model.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';

class FamilyInfoSection extends StatelessWidget {
  final CardDetailsData data;
  const FamilyInfoSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.5, color: AppColors.buttonColor1.withAlpha(77)),
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FixedColumnWidth(1), 2: FlexColumnWidth(1)},
        border: TableBorder.symmetric(inside: BorderSide.none, outside: BorderSide.none),
        children: [
          _headerRow(),
          ..._familyRows(data),
        ],
      ),
    );
  }

  TableRow _headerRow() => TableRow(
        decoration: BoxDecoration(color: AppColors.buttonColor1.withAlpha(30)),
        children: [
          _headerCell("Family Details"),
          SizedBox(width: 1, child: ColoredBox(color: AppColors.buttonColor1)),
          _headerCell("Age", align: TextAlign.center),
        ],
      );

  List<TableRow> _familyRows(CardDetailsData data) {
    return [
      for (int i = 0; i < data.familyMembers.length; i++) ...[
        TableRow(
          decoration: BoxDecoration(
            color: i.isEven ? AppColors.buttonColor1.withAlpha(10) : Colors.transparent,
          ),
          children: [
            _cell(data.familyMembers[i].name),
            SizedBox(width: 1, child: ColoredBox(color: AppColors.buttonColor1)),
            _cell("${_calculateAge(data.familyMembers[i].dateOfBirth)}", align: TextAlign.center),
          ],
        ),
        if (i != data.familyMembers.length - 1)
          TableRow(
            children: List.generate(3, (_) {
              return Container(height: 1, color: AppColors.buttonColor1.withAlpha(60));
            }),
          ),
      ],
    ];
  }

  Widget _headerCell(String title, {TextAlign align = TextAlign.start}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.h),
        child: CustomText(
          title: title,
          fontSize: 16.sp,
          weight: FontWeight.bold,
          color: AppColors.buttonColor1,
          alignText: align,
        ),
      );

  Widget _cell(String title, {TextAlign align = TextAlign.start}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 1.3.h, horizontal: 2.h),
        child: CustomText(
          title: title,
          fontSize: 16.sp,
          weight: FontWeight.w500,
          alignText: align,
        ),
      );

  int _calculateAge(String dob) {
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }
}
