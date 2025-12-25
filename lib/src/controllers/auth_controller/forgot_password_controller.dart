import 'package:cicl_app/src/states/auth_state/forgot_password_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordController() : super(ForgotPasswordInitial());

  Future<void> sendResetLink(String email) async {
    state = ForgotPasswordLoading();

    try {
      // Simulating API call with delay (replace with real API later)
      await Future.delayed(const Duration(seconds: 2));

      // Assume success
      state = ForgotPasswordSuccess("Message sent to $email");
    } catch (e) {
      state = ForgotPasswordError("Something went wrong");
    }
  }
}
