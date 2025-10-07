import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/models/profile_model/card_detail_model.dart';
import 'profile_detail_card.dart';

class EmployeeInfoSection extends StatelessWidget {
  final CardDetailsData data;
  const EmployeeInfoSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.h),
      decoration: BoxDecoration(
        color: AppColors.buttonColor1.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        key: const ValueKey(1),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileDetailCard(label: 'Age', value: data.age.toString()),
          _divider(),
          ProfileDetailCard(label: 'Employee ID', value: data.employeeId),
          _divider(),
          ProfileDetailCard(label: 'CNIC', value: data.cnic),
          _divider(),
          ProfileDetailCard(label: 'Room Limit', value: data.limits.roomLimit),
          _divider(),
          ProfileDetailCard(label: 'Normal Delivery', value: data.limits.normalDelivery),
          _divider(),
          ProfileDetailCard(label: 'C-Section', value: data.limits.cSection),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: AppColors.buttonColor1.withAlpha(77), height: 2.h);
}
