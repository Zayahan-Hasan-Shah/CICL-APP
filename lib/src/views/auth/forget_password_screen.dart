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

    ref.listen<ForgotPasswordState>(
      forgotPasswordControllerProvider,
      (previous, next) {
        if (next is ForgotPasswordSuccess) {
          _showSuccessDialog(next.message);
        } else if (next is ForgotPasswordError) {
          _showErrorDialog(next.message);
        }
      },
    );
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.all(0.2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CompanyNameWidget(),
                SizedBox(height: 6.h),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: 'Forgot Password',
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
                              SizedBox(height: 0.5.h),
                              buildEmailTextField(),
                              SizedBox(height: 6.h),
                              SizedBox(
                                width: double.infinity,
                                height: 14.w,
                                child: forgotState is ForgotPasswordLoading
                                    ? const Center(child: LoadingIndicator())
                                    : CustomButton(
                                        text: 'Send Password',
                                        fontSize: 16.sp,
                                        onPressed: _forgotPassword,
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.buttonColor1,
                                            AppColors.buttonColor2,
                                          ],
                                        ),
                                        borderRadius: 12,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
