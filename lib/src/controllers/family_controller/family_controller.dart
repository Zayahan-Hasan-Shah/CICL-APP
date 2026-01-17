import 'dart:convert';

import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/family_model/family_model.dart';
import 'package:cicl_app/src/states/family_state/family_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
// import 'package:cicl_app/src/controllers/network_controller/optimized_http_client.dart';

class FamilyController extends StateNotifier<FamilyState> {
  FamilyController() : super(FamilyState());

  Future<void> fetchFamilyMembers() async {
    final StorageService storage = StorageService();
    try {
      state = state.copyWith(loading: true, error: null);
      final token = await StorageService().getAccessToken();
      final url = Uri.parse(ApiUrl.familyMembers);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "User-Agent": "CICL-Mobile-App/1.0",
        },
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List<dynamic> data = jsonBody['data'];

        final familyMembers = data.map((e) => FamilyModel.fromJson(e)).toList();
        final userName = await storage.getName() ?? '';
        await storage.saveUserAndFamilyNames(
          userName: userName,
          familyNames: familyMembers,
        );

        state = state.copyWith(
          loading: false,
          error: null,
          family: familyMembers,
        );
      } else {
        state = state.copyWith(loading: false, error: "Please try again later");
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}