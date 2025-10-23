import 'dart:developer';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/providers/auth_provider/login_provider.dart';
import 'package:cicl_app/src/providers/auth_provider/fingerprint_auth_provider.dart';
import 'package:cicl_app/src/routing/routes_names.dart';
import 'package:cicl_app/src/states/auth_state/login_state.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_textfield.dart';
import 'package:cicl_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class LoginFormWidget extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;
  final bool enableFingerprintOption;

  const LoginFormWidget({
    super.key,
    this.onLoginSuccess,
    this.enableFingerprintOption = true,
  });

  @override
  ConsumerState<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends ConsumerState<LoginFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _enableFingerprintLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildEmailTextField() {
    return CustomTextField(
      hintText: 'User Name or Email',
      controller: _emailController,
      validator: AppValidation.checkText,
      suffixIcon: IconButton(
        icon: SvgPicture.asset(AppAssets.cutIcon, height: 20, width: 20),
        onPressed: () => _emailController.clear(),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return CustomTextField(
      hintText: '**************',
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: AppValidation.checkText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
            log("LoginScreen → Password visibility: $_obscurePassword");
          });
        },
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _emailController.text.trim();
      final password = _passwordController.text.trim();

      log("LoginScreen → Attempting login with $username");
      try {
        final response = await ref
            .read(authControllerProvider.notifier)
            .login(username, password, ref);
        log('Login Screen -> Response');
        log('Response Body : $response');

        if (response != null) {
          // If fingerprint login is enabled, set it up
          if (_enableFingerprintLogin && widget.enableFingerprintOption) {
            // Show a dialog to confirm fingerprint login setup
            final confirmSetup = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Enable Fingerprint Login'),
                content: const Text(
                  'Do you want to enable fingerprint login for this account?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(true),
                    child: const Text('Enable'),
                  ),
                ],
              ),
            );

            if (confirmSetup == true) {
              // Explicitly enable fingerprint login before setup
              final storageService = StorageService();
              await storageService.enableFingerprintLogin(username, password);

              // Setup fingerprint login
              await ref
                  .read(fingerprintAuthProvider.notifier)
                  .setupFingerprintLogin(username, password, ref);

              // Verify fingerprint login is enabled
              final isEnabled = await storageService
                  .isFingerprintLoginEnabled();
              log('Fingerprint Login Enabled After Setup: $isEnabled');
            }
          }

          // Call onLoginSuccess if provided, otherwise navigate to dashboard
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!();
            context.go('/dashboardscreen', extra: 0);
          } else {
            context.go('/dashboardscreen', extra: 0);
          }
        } else {
          log("LoginScreen → Login failed, response is null");
        }
      } catch (e, st) {
        log("LoginScreen → Exception during login: $e\n$st");
      }
    } else {
      log("LoginScreen → Form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: 'Sign in',
            fontSize: 20.sp,
            weight: FontWeight.w500,
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: const CustomText(
              title: 'User name or email',
              fontSize: 16,
              weight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 2.h),
          _buildEmailTextField(),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: const CustomText(
              title: 'Password',
              fontSize: 16,
              weight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPasswordTextField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.push(RoutesNames.forgotPasswordScreen);
                },
                child: const CustomText(
                  title: 'Forgot Password?',
                  fontSize: 16,
                  weight: FontWeight.w500,
                  color: Colors.black,
                  underLine: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          if (widget.enableFingerprintOption)
            Row(
              children: [
                Checkbox(
                  value: _enableFingerprintLogin,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableFingerprintLogin = value ?? false;
                    });
                  },
                ),
                const Text('Enable Fingerprint Login'),
              ],
            ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            height: 14.w,
            child: authState is AuthLoading
                ? const Center(child: LoadingIndicator())
                : CustomButton(
                    text: 'Sign In',
                    fontSize: 16.sp,
                    onPressed: _login,
                    gradient: const LinearGradient(
                      colors: [AppColors.buttonColor1, AppColors.buttonColor2],
                    ),
                    borderRadius: 12,
                  ),
          ),
        ],
      ),
    );
  }
}
