import 'dart:io';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/auth_provider/fingerprint_auth_provider.dart';
import 'package:cicl_app/src/providers/auth_provider/face_id_auth_provider.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class BiometricLoginWidget extends ConsumerWidget {
  final WidgetRef ref;
  final BuildContext context;

  const BiometricLoginWidget({
    super.key, 
    required this.ref, 
    required this.context,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showFaceId = Platform.isIOS;
    const showFingerprint = true; // fingerprint is available on both Android and iOS

    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showFaceId) ...[
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.face_unlock_outlined,
                        size: 35.sp,
                        color: AppColors.buttonColor1,
                      ),
                      onPressed: () {
                        ref
                            .read(faceIdAuthProvider.notifier)
                            .authenticateWithBiometrics(context, ref);
                      },
                      tooltip: 'Login with Face ID',
                    ),
                    CustomText(
                      title: 'Face ID',
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ],
                ),
                if (showFingerprint) SizedBox(width: 8.w),
              ],
              if (showFingerprint)
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.fingerprint,
                        size: 35.sp,
                        color: AppColors.buttonColor1,
                      ),
                      onPressed: () {
                        ref
                            .read(fingerprintAuthProvider.notifier)
                            .authenticateWithBiometrics(context, ref);
                      },
                      tooltip: 'Login with Fingerprint',
                    ),
                    CustomText(
                      title: 'Fingerprint',
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ],
                ),
            ],
          ),
        SizedBox(height: 2.h,),
        CustomText(
            title: 'Or login with',
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
