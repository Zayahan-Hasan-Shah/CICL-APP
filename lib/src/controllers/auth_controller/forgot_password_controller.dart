import 'dart:convert';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/states/auth_state/forgot_password_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordController() : super(ForgotPasswordInitial());

  Future<void> sendResetLink(String email) async {
    state = ForgotPasswordLoading();

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.forgotPasswordUrl),
        headers: {
          "Content-Type": "application/json",
          "User-Agent": "CICL-Mobile-App/1.0",
        },
        body: jsonEncode({"username": email}),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody["code"] == 200) {
          state = ForgotPasswordSuccess(
            jsonBody["message"] ?? "Reset link sent to $email",
          );
        } else {
          state = ForgotPasswordError(
            jsonBody["message"] ?? "Failed to send reset link",
          );
        }
      } else {
        state = ForgotPasswordError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      state = ForgotPasswordError("Something went wrong: ${e.toString()}");
    }
  }
}