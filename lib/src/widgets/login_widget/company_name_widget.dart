import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CompanyNameWidget extends StatelessWidget {
  const CompanyNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(
              AppAssets.logoImage,
              height: 10.h,
              width: 26.w,
            ),
            SizedBox(width: 2.w),
            Image.asset(
              AppAssets.textLogoBlackImage,
              height: 5.h,
              alignment: Alignment.center,  
            ),
          ],
        )
      ],
    );
  }
}
