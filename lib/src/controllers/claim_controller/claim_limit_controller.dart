import 'dart:convert';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/claim_model.dart/claim_limit_model.dart';
import 'package:cicl_app/src/states/claim_state/claim_limit_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class ClaimLimitController extends StateNotifier<ClaimLimitState> {
  ClaimLimitController() : super(ClaimLimitState());

  Future<void> fetchClaimLimits() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await StorageService().getAccessToken();
      final cardNo = await StorageService().getCardNumber();

      if (cardNo == null || cardNo.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error:
              "Employee Card Number is required. Please update your profile.",
        );
        return;
      }

      final url = Uri.parse(ApiUrl.userLimitUrl);
      final bodySent = jsonEncode({
        "cardNumber": cardNo,
        "year": DateTime.now().year.toString(),
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "User-Agent": "CICL-Mobile-App/1.0",
        },
        body: bodySent,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data is Map<String, dynamic> && data['code'] == 200) {
          final model = UserClaimLimit.fromJson(data);
          state = state.copyWith(isLoading: false, data: model);
        } else if (data is Map<String, dynamic> && data['code'] == 400) {
          final errorMessage = data['message'] ?? 'An error occurred';
          state = state.copyWith(isLoading: false, error: errorMessage);
        } else {
          state = state.copyWith(
            isLoading: false,
            error: "Unexpected response format",
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: data['message'] ?? "Failed to load claim limits",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }
}