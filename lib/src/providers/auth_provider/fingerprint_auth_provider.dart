import 'package:cicl_app/src/controllers/auth_controller/fingerprint_auth_controller.dart';
import 'package:cicl_app/src/states/auth_state/fingerprint_auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final fingerprintAuthProvider =
    StateNotifierProvider<FingerprintAuthController, FingerprintAuthState>(
      (ref) => FingerprintAuthController(),
    );
