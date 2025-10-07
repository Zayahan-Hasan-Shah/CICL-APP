import 'dart:developer';

import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/profile_model/card_detail_model.dart';
import 'package:cicl_app/src/states/profile_state/card_detail_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class CardDetailsController extends StateNotifier<CardDetailsState> {
  CardDetailsController() : super(const CardDetailsState());

  Future<void> fetchCardDetails() async {
    state = state.copyWith(isLoading: true);

    try {
      log("*** API URL : ${ApiUrl.familyMembers} ***");
      final token = await StorageService().getAccessToken();
      log("CardDetailController → Using access token: $token");
      final url = Uri.parse(ApiUrl.cardDetailUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("CardDetailController → Response status: ${response.statusCode}");
      log("CardDetailController → Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = cardDetailsResponseFromJson(response.body);
        if (result.data != null) {
          state = state.copyWith(isLoading: false, data: result.data);
        } else {
          state = state.copyWith(isLoading: false, error: "No data found");
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed with code: ${response.statusCode}",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
