import 'dart:convert';
import 'dart:developer';
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
      log("*** API URL : ${ApiUrl.userLimitUrl} ***");
      final token = await StorageService().getAccessToken();
      // final cardNo = await StorageService().getCardNumber();
      final cardNo = await StorageService().getCardNumber();
      log("CRNO : $cardNo");
      // Validate card number
      if (cardNo == null || cardNo.isEmpty) {
        log("ClaimLimitController → No card number found");
        state = state.copyWith(
          isLoading: false, 
          error: "Employee Card Number is required. Please update your profile."
        );
        return;
      }

      log("ClaimLimitController → Using token: $token");
      log("ClaimLimitController → Using card: $cardNo");

      final url = Uri.parse(ApiUrl.userLimitUrl);
      final bodySent = jsonEncode({
        "cardNumber": cardNo, 
        "year": DateTime.now().year.toString()
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: bodySent,
      );

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      final data = json.decode(response.body);

      // Handle different response scenarios
      if (response.statusCode == 200) {
        if (data is Map<String, dynamic> && data['code'] == 200) {
          // Successful response with data
          try {
            final model = UserClaimLimit.fromJson(data);
            state = state.copyWith(isLoading: false, data: model);
          } catch (e) {
            log("ClaimLimitController → Error parsing claim limits: $e");
            log("Problematic JSON data: $data");
            state = state.copyWith(
              isLoading: false, 
              error: "Failed to parse claim limits: ${e.toString()}"
            );
          }
        } else if (data is Map<String, dynamic> && data['code'] == 400) {
          // Handle specific error messages
          final errorMessage = data['message'] ?? 'An error occurred';
          state = state.copyWith(
            isLoading: false, 
            error: errorMessage
          );
        } else {
          // Unexpected response format
          log("ClaimLimitController → Unexpected response format");
          log("Received data type: ${data.runtimeType}");
          log("Received data: $data");
          state = state.copyWith(
            isLoading: false, 
            error: "Unexpected response format"
          );
        }
      } else {
        // HTTP error
        log("ClaimLimitController → HTTP error");
        log("Response status code: ${response.statusCode}");
        log("Response body: ${response.body}");
        state = state.copyWith(
          isLoading: false, 
          error: data['message'] ?? "Failed to load claim limits"
        );
      }
    } catch (e) {
      log("ClaimLimitController → Error: $e");
      state = state.copyWith(
        isLoading: false, 
        error: "An unexpected error occurred: ${e.toString()}"
      );
    }
  }
}
