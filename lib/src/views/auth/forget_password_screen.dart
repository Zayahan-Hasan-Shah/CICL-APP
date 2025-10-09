import 'dart:developer';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/providers/auth_provider/forgot_password_provider.dart';
import 'package:cicl_app/src/routing/routes_names.dart';
import 'package:cicl_app/src/states/auth_state/forgot_password_state.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_textfield.dart';
import 'package:cicl_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:cicl_app/src/widgets/login_widget/company_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordControllerProvider);

    ref.listen<ForgotPasswordState>(forgotPasswordControllerProvider, (
      previous,
      next,
    ) {
      if (next is ForgotPasswordSuccess) {
        // Show success dialog and navigate to login
        _showSuccessDialog(next.message);
      } else if (next is ForgotPasswordError) {
        // Show error dialog
        _showErrorDialog(next.message);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5.h),
                  const CompanyNameWidget(),
                  SizedBox(height: 5.h),
                  SvgPicture.asset(
                    AppAssets.claimIcon, // Use an existing icon
                    height: 25.h,
                  ),
                  SizedBox(height: 3.h),
                  CustomText(
                    title: 'Forgot Password',
                    fontSize: 22.sp,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    title: 'Enter your email to reset password',
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 3.h),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    validator: AppValidation.checkText,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _emailController.clear(),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Show loading indicator when in loading state
                  if (forgotState is ForgotPasswordLoading)
                    const LoadingIndicator()
                  else
                    CustomButton(
                      onPressed: _forgotPassword,
                      text: 'Reset Password',
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.buttonColor1,
                          AppColors.buttonColor2,
                        ],
                      ),
                    ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(title: 'Remember password? ', fontSize: 14.sp),
                      GestureDetector(
                        onTap: () => context.go(RoutesNames.loginScreen),
                        child: CustomText(
                          title: 'Login',
                          fontSize: 14.sp,
                          color: AppColors.buttonColor1,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return CustomTextField(
      hintText: 'User Name or Email',
      controller: _emailController,
      validator: AppValidation.checkText,
      suffixIcon: IconButton(
        icon: SvgPicture.asset(
          AppAssets.cutIcon, // points to your assets/icons/cut_icon.svg
          height: 20,
          width: 20,
        ),
        onPressed: () => _emailController.clear(),
      ),
    );
  }

  Future<void> _forgotPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      log("ForgotPassword → Attempting login with $email");
      await ref
          .read(forgotPasswordControllerProvider.notifier)
          .sendResetLink(email);
    } else {
      log("Forgot Password → Form validation failed");
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RoutesNames.loginScreen);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
