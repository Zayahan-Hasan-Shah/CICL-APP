import 'dart:developer';

import 'package:cicl_app/src/providers/auth_provider/fingerprint_auth_provider.dart';
import 'package:cicl_app/src/states/auth_state/fingerprint_auth_state.dart';
import 'package:cicl_app/src/widgets/login_widget/login_form_widget.dart';
import 'package:cicl_app/src/widgets/login_widget/fingerprint_login_widget.dart';
import 'package:cicl_app/src/widgets/login_widget/company_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // Listen to fingerprint auth state
    ref.listen<FingerprintAuthState>(fingerprintAuthProvider, (previous, next) {
      if (next is FingerprintAuthSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.green),
        );
        // Optionally navigate or show success dialog
      } else if (next is FingerprintAuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
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
                        LoginFormWidget(
                          onLoginSuccess: () {
                            // Custom login success handling if needed
                            log('Login successful');
                          },
                        ),
                        const SizedBox(height: 8),
                        // Fingerprint Login Button
                        FingerprintLoginWidget(ref: ref, context: context),
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
}
