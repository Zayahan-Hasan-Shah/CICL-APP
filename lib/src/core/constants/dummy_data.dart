import 'dart:developer';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_limit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      log("BMI -> taps");
      context.push('/bmiscreen');
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
    },
  },
  {
    "id": 5,
    "icon": AppAssets.otherIcon,
    "title": "Discount Centres",
    "iconBgColor": AppColors.buttonColor1,
    "onTap": (WidgetRef ref, BuildContext context) {
      log("Other Benefits -> taps");
      context.push('/laboratorylistscreen');
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
    },
  },
];
