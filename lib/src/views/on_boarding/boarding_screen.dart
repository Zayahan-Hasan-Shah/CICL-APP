import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/routing/routes_names.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/on_boarding_widget/custom_clipper_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildClipper(),
                _buildText(),
                _builButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClipper() {
    return ClipPath(
      clipper: CustomClipperWidget(),
      child: Container(
        height: 50.h,
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 0.75.h),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            image: DecorationImage(
              image: AssetImage(AppAssets.backgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.backgroundColor.withValues(alpha: 0.2),
                BlendMode.srcATop,
              ),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logoImage,
              height: 15.h,
            ),
            Image.asset(
              AppAssets.textLogoImage,
              height: 6.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return Padding(
      padding: EdgeInsetsGeometry.all(2.h),
      child: Column(
        children: [
          CustomText(
            title: "Welcome to CICL",
            weight: FontWeight.w800,
            fontStyle: FontStyle.normal,
            fontSize: 20.sp,
            color: Colors.black,
          ),
          SizedBox(height: 0.5.h),
          CustomText(
            title:
                "Lorem ipsum dolor sit amet, consectetur\n adipiscing elit. Vestibulum mollis nunc a molestie\n dictum. Mauris venenatis, felis consectetur\n adipiscing elit. Vestibulum mollis nunc a ",
            weight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 15.sp,
            color: Colors.black,
            alignText: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _builButton() {
    return CustomButton(
      text: "Let's Start",
      onPressed: () {context.go(RoutesNames.loginScreen);},
      width: 60.w,
      gradient: LinearGradient(colors: AppColors.buttonGradientColor),
    );
  }
}
