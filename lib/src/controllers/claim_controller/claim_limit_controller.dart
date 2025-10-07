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
      final cardNo = await StorageService().getCardNumber();
      log("ClaimLimitController → Using token: $token");
      log("ClaimLimitController → Using card: $cardNo");

      final url = Uri.parse(ApiUrl.userLimitUrl);
      final bodySent = jsonEncode({"cardNumber": cardNo, "year": "2024"});

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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = UserClaimLimit.fromJson(data);
        state = state.copyWith(isLoading: false, data: model);
      } else {
        state = state.copyWith(isLoading: false, error: "Failed to load data");
      }
    } catch (e) {
      log("ClaimLimitController → Error: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
