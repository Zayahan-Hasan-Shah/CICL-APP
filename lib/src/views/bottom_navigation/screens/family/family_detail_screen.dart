import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/family_widget/family_detail_section_1.dart';
import 'package:cicl_app/src/widgets/family_widget/family_detail_section_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class FamilyDetailScreen extends StatelessWidget {
  final String name;
  final String relation;
  final String gender;
  final String cnicBform;
  final String dateOfBirth;
  const FamilyDetailScreen({
    super.key,
    required this.name,
    required this.relation,
    required this.gender,
    required this.cnicBform,
    required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.chevron_left_outlined),
        ),
        title: CustomText(
          title: name,
          weight: FontWeight.w700,
          color: Colors.black,
          alignText: TextAlign.center,
          fontSize: 18.sp,
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(4.h),
        child: Column(
          children: [
            FamilyDetailSection1(name: name),
            SizedBox(height: 3.h),
            FamilyDetailSection2(
              cnicBform: cnicBform,
              relation: relation,
              gender: gender,
              dateOfBirth: dateOfBirth,
            ),
          ],
        ),
      ),
    );
  }
}
