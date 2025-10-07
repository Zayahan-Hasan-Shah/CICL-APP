import 'package:cicl_app/src/core/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/models/profile_model/card_detail_model.dart';
import 'profile_detail_card.dart';

class OfficeInfoSection extends StatelessWidget {
  final CardDetailsData data;
  const OfficeInfoSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.h),
      decoration: BoxDecoration(
        color: AppColors.buttonColor1.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        key: const ValueKey(0),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileDetailCard(label: 'Client Name', value: data.clientName),
          _divider(),
          ProfileDetailCard(label: 'Policy Number', value: data.policyNumber),
          _divider(),
          ProfileDetailCard(label: 'Expiry Date', value: data.expiryDate),
          _divider(),
          ProfileDetailCard(label: 'Employee Name', value: data.employeeName.toTitleCase()),
          _divider(),
          ProfileDetailCard(label: 'Designation', value: data.employeeDesignation),
          _divider(),
          ProfileDetailCard(label: 'Card Number', value: data.cardNumber),
          _divider(),
          ProfileDetailCard(label: 'Plan', value: data.plan),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: AppColors.buttonColor1.withAlpha(77), height: 2.h);
}
