import 'dart:io';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/constants/app_launcher_manager.dart';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/providers/auth_provider/login_provider.dart';
import 'package:cicl_app/src/routing/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';

/// Custom upgrader messages that override the default English strings.
class _CiclUpgraderMessages extends UpgraderMessages {
  @override
  String get title => 'New Update Available';

  @override
  String get body =>
      'A new version of the CICL app is available. '
      'Please update to continue using the app.';

  @override
  String get buttonTitleUpdate => 'Update Now';
}


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  Future<bool> _verifyTokenWithServer(String token) async {
    try {
      final uri = Uri.parse(ApiUrl.cardDetailUrl);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 401) return false;
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

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
      if (!mounted) return;
      try {
        final firstLaunch = await AppLaunchManager.isFirstLaunch();
        if (!mounted) return;
        if (firstLaunch) {
          context.go(RoutesNames.onBoardingScreen);
        } else {
          // Check for existing valid login token
          final storageService = StorageService();
          final isLoggedIn = await storageService.isTokenValid();
          if (!mounted) return;

          if (isLoggedIn) {
            final token = await storageService.getAccessToken();
            if (!mounted) return;

            if (token == null || token.isEmpty) {
              context.go(RoutesNames.loginScreen);
              return;
            }

            final serverValid = await _verifyTokenWithServer(token);
            if (!mounted) return;

            if (!serverValid) {
              await storageService.fullLogout();
              if (!mounted) return;
              context.go(RoutesNames.loginScreen);
              return;
            }

            await ref
                .read(authControllerProvider.notifier)
                .initializeUserSession(ref);
            if (!mounted) return;
            context.go(RoutesNames.dashboardScreen, extra: 0);
          } else {
            context.go(RoutesNames.loginScreen);
          }
        }
      } catch (e) {
        if (!mounted) return;
        context.go(RoutesNames.loginScreen);
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
    return UpgradeAlert(
      // ── Force-update settings ──────────────────────────────────────────
      barrierDismissible: false,   // tapping outside does nothing
      showIgnore: false,           // no "Ignore" button
      showLater: false,            // no "Later" / "Skip" button
      showReleaseNotes: false,     // keep dialog clean
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      upgrader: Upgrader(
        // Re-prompt on every launch — no cooldown
        durationUntilAlertAgain: Duration.zero,
        // Custom CICL messages
        messages: _CiclUpgraderMessages(),
      ),
      // ──────────────────────────────────────────────────────────────────
      child: Scaffold(
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
              ),
            ),
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
                    Image.asset(AppAssets.logoImage, height: 20.h),
                    Image.asset(AppAssets.textLogoImage, height: 6.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
