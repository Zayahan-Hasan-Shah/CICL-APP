import 'dart:convert';
import 'dart:developer';

import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/family_model/family_model.dart';
import 'package:cicl_app/src/states/family_state/family_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class FamilyController extends StateNotifier<FamilyState> {
  FamilyController() : super(FamilyState());

  Future<void> fetchFamilyMembers() async {
    try {
      log("*** API URL : ${ApiUrl.familyMembers} ***");
      state = state.copyWith(loading: true, error: null);
      final token = await StorageService().getAccessToken();
      log("FamilyController → Using access token: $token");
      final url = Uri.parse(ApiUrl.familyMembers);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      log("Family Controller → Response status: ${response.statusCode}");
      log("Family Controller → Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List<dynamic> data = jsonBody['data'];

        final familyMembers = data.map((e) => FamilyModel.fromJson(e)).toList();

        state = state.copyWith(
          loading: false,
          family: familyMembers,
        );
      } else {
        state = state.copyWith(
            loading: false,
            error:
                "Please try again later");
      }
    } catch (e, st) {
      log("Family Controller → Error: $e\n$st");
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }
}
