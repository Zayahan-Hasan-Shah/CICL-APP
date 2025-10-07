import 'dart:developer';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/constants/app_launcher_manager.dart';
import 'package:cicl_app/src/routing/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);

    _controller?.forward();
    Future.delayed(const Duration(seconds: 3), () async {
      try {
        final firstLaunch = await AppLaunchManager.isFirstLaunch();
        if (firstLaunch) {
          context.go(RoutesNames.onBoardingScreen);
        } else {
          context.go(RoutesNames.loginScreen);
        }
      } catch (e) {
        log(e.toString());
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,
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
            child: Center(
              child: AnimatedBuilder(
                animation: _animation!,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation?.value ?? 1,
                    child: Transform.scale(
                      scale: _animation?.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.logoImage,
                      height: 20.h,
                    ),
                    Image.asset(
                      AppAssets.textLogoImage,
                      height: 6.h,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
