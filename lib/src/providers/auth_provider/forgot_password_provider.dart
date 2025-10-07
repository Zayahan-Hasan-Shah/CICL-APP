import 'package:cicl_app/src/controllers/auth_controller/forgot_password_controller.dart';
import 'package:cicl_app/src/states/auth_state/forgot_password_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
  (ref) => ForgotPasswordController(),
);