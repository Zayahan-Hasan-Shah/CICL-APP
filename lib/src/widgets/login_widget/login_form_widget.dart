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
  bool _showEmailSuffix = false;
  bool _showPasswordSuffix = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      final hasText = _emailController.text.isNotEmpty;
      if (hasText != _showEmailSuffix) {
        setState(() {
          _showEmailSuffix = hasText;
        });
      }
    });

    _passwordController.addListener(() {
      final hasText = _passwordController.text.isNotEmpty;
      if (hasText != _showPasswordSuffix) {
        setState(() {
          _showPasswordSuffix = hasText;
        });
      }
    });
  }

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
      suffixIcon: _showEmailSuffix
          ? IconButton(
              icon: SvgPicture.asset(AppAssets.cutIcon, height: 20, width: 20),
              onPressed: () => _emailController.clear(),
            )
          : null,
    );
  }

  Widget _buildPasswordTextField() {
    return CustomTextField(
      hintText: '**************',
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: AppValidation.checkText,
      suffixIcon: _showPasswordSuffix
          ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
          : null,
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final response = await ref
            .read(authControllerProvider.notifier)
            .login(username, password, ref);

        if (response != null) {
          if (!mounted) return;
          // Show success SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful'),
              backgroundColor: Colors.green,
            ),
          );

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

              if (!mounted) return;
              // Verify fingerprint login is enabled
              final isEnabled = await storageService
                  .isFingerprintLoginEnabled();
            }
          }

          // Call onLoginSuccess if provided, otherwise navigate to dashboard
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!();
            if (!mounted) return;
            context.go('/dashboardscreen', extra: 0);
          } else {
            if (!mounted) return;
            context.go('/dashboardscreen', extra: 0);
          }
        } else {
          // Show error SnackBar for login failures
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(authControllerProvider) is AuthError
                    ? (ref.read(authControllerProvider) as AuthError).message
                    : 'Login failed. Please try again.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // Show error SnackBar for any unexpected exceptions
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An unexpected error occurred: $e',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {}
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
                : authState is AuthError
                ? CustomButton(
                    text: 'Sign In',
                    fontSize: 16.sp,
                    onPressed: _login,
                    gradient: const LinearGradient(
                      colors: [AppColors.buttonColor1, AppColors.buttonColor2],
                    ),
                    borderRadius: 12,
                  )
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
