import 'dart:developer';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_limit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map<String, dynamic>> dummyInfoCardData = [
  {
    "id": 1,
    "icon": AppAssets.claimIcon,
    "title": "My Claims",
    "iconBgColor": AppColors.buttonColor1,
    "onTap": (WidgetRef ref, BuildContext context) {
      ref
          .read(bottomNavigationProvider.notifier)
          .setIndex(2); // Claim tab index
    },
  },
  {
    "id": 2,
    "icon": AppAssets.familyIcon,
    "title": "My Family",
    "iconBgColor": AppColors.buttonColor1,
    "onTap": (WidgetRef ref, BuildContext context) {
      ref
          .read(bottomNavigationProvider.notifier)
          .setIndex(1); // Family tab index
    },
  },
  {
    "id": 3,
    "icon": AppAssets.bmiIcon,
    "title": "BMI",
    "iconBgColor": AppColors.buttonColor1,
    "onTap": (WidgetRef ref, BuildContext context) async {
      const url = 'https://www.calculator.net/bmi-calculator.html';
      final uri = Uri.parse(url);

      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          log("Could not launch BMI calculator URL");
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Unable to open the BMI calculator."),
            backgroundColor: AppColors.redColor,
            ),
          );
        }
      } catch (e) {
        log("Error launching BMI calculator: $e");
      }
    },
  },
  {
    "id": 4,
    "icon": AppAssets.locationIcon,
    "title": "Panel Hospitals",
    "iconBgColor": AppColors.buttonColor1,
    "onTap": (WidgetRef ref, BuildContext context) {
      log("Panel Hospitals -> taps");
      context.push('/hospitallistscreen');
      // Example: navigate to Panel Hospital screen separately
      // context.push('/panelhospitalsscreen');
    },
  },
  {
    "id": 5,
    "icon": AppAssets.otherIcon,
    "title": "Other Benefits",
    "iconBgColor": AppColors.buttonColor1,
    "onTap": (WidgetRef ref, BuildContext context) {
      log("Other Benefits -> taps");
      context.push('/laboratorylistscreen');
      // Example: navigate to other benefits screen separately
      // context.push('/otherbenefitsscreen');
    },
  },
  {
    "id": 6,
    "icon": AppAssets.extraIcon,
    "title": "Claim Limit",
    "iconBgColor": AppColors.buttonColor1,
    "onTap": (WidgetRef ref, BuildContext context) {
      log("Extra -> taps");
      ref.read(claimLimitProvider.notifier).fetchClaimLimits();
      context.push('/claimlimitscreen');

      // Example: navigate to extras screen separately
    },
  },
];
