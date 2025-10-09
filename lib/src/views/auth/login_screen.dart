import 'dart:developer';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/providers/auth_provider/login_provider.dart';
import 'package:cicl_app/src/providers/auth_provider/fingerprint_auth_provider.dart';
import 'package:cicl_app/src/routing/routes_names.dart';
import 'package:cicl_app/src/states/auth_state/login_state.dart';
import 'package:cicl_app/src/states/auth_state/fingerprint_auth_state.dart';
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    // Remove unused fingerprintState variable
    ref.watch(fingerprintAuthProvider);

    // Fingerprint authentication listener
    ref.listen<FingerprintAuthState>(fingerprintAuthProvider, (previous, next) {
      if (next is FingerprintAuthSuccess) {
        // Navigate to dashboard on successful authentication
        context.go('/dashboardscreen', extra: 0);
      } else if (next is FingerprintAuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      } else if (next is FingerprintAuthNotAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.orange),
        );
      }
    });

    // Existing authentication state handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(4.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CompanyNameWidget(),
                        SizedBox(height: 2.w),
                        Form(
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
                              buildEmailTextField(),
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
                              buildPasswordTextField(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.push(
                                        RoutesNames.forgotPasswordScreen,
                                      );
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
                              SizedBox(height: 6.h),
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
                                          colors: [
                                            AppColors.buttonColor1,
                                            AppColors.buttonColor2,
                                          ],
                                        ),
                                        borderRadius: 12.0,
                                      ),
                              ),
                              const SizedBox(height: 8.0),
                              // Fingerprint Login Button
                              Center(
                                child: Column(
                                  children: [
                                    const CustomText(
                                      title: 'Or login with',
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16.0),
                                    IconButton(
                                      icon: Icon(
                                        Icons.fingerprint,
                                        size: 50.0,
                                        color: AppColors.buttonColor1,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                              fingerprintAuthProvider.notifier,
                                            )
                                            .authenticateWithBiometrics();
                                      },
                                      tooltip: 'Login with Fingerprint',
                                    ),
                                    const CustomText(
                                      title: 'Fingerprint Login',
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
        icon: SvgPicture.asset(AppAssets.cutIcon, height: 20, width: 20),
        onPressed: () => _emailController.clear(),
      ),
    );
  }

  Widget buildPasswordTextField() {
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
          context.go('/dashboardscreen', extra: 0);
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
}
