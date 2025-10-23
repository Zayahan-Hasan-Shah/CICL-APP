import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/services/logout_service.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';

Future<void> showLogoutConfirmationDialog(BuildContext context) async {
  // Create a LogoutService instance
  final logoutService = LogoutService(StorageService());

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const CustomText(
          title: 'Confirm Logout',
          color: Colors.black87,
          weight: FontWeight.bold,
        ),
        content: const CustomText(
          title: 'Are you sure you want to logout?',
          color: Colors.black87,
        ),
        actions: <Widget>[
          TextButton(
            child: CustomText(
              title: 'Cancel',
              color: AppColors.greenColor,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss dialog
            },
          ),
          TextButton(
            child: CustomText(
              title: 'Logout',
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss dialog
              logoutService.logout(context); // Perform logout
            },
          ),
        ],
      );
    },
  );
}
