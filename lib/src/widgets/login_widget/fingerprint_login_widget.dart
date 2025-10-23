import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/auth_provider/fingerprint_auth_provider.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class FingerprintLoginWidget extends ConsumerWidget {
  final WidgetRef ref;
  final BuildContext context;

  const FingerprintLoginWidget({
    super.key, 
    required this.ref, 
    required this.context,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          CustomText(
            title: 'Or login with',
            fontSize: 14.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 2.h),
          IconButton(
            icon: Icon(
              Icons.fingerprint,
              size: 35.sp,
              color: AppColors.buttonColor1,
            ),
            onPressed: () {
              ref
                  .read(
                    fingerprintAuthProvider.notifier,
                  )
                  .authenticateWithBiometrics(
                    context,
                    ref,
                  );
            },
            tooltip: 'Login with Fingerprint',
          ),
          CustomText(
            title: 'Fingerprint Login',
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
