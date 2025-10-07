import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const CustomText(
        title: 'Confirm Logout',
        color: Colors.black87,
      ),
      content: const CustomText(
        title: 'Are you sure you want to logout?',
        color: Colors.black87,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: CustomText(
            title: 'Cancel',
            color: AppColors.greenColor,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: CustomText(
            title: 'Logout',
            color: AppColors.greenColor,
          ),
        ),
      ],
    ),
  );
}
