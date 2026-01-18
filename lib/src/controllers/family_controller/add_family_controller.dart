import 'dart:convert';

import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/family_model/add_family_model.dart';
import 'package:cicl_app/src/states/family_state/add_family_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class AddFamilyController extends StateNotifier<AddFamilyState> {
  AddFamilyController() : super(AddFamilyState());

  Future<void> addFamilyMember(AddFamilyModel model) async {
    try {
      state = state.copyWith(loading: true, error: null, message: null);
      final token = await StorageService().getAccessToken();

      final uri = Uri.parse(ApiUrl.addFamilyMembers);

      final request = http.MultipartRequest("POST", uri)
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "User-Agent": "CICL-Mobile-App/1.0",
        })
        ..fields.addAll(
          model.toFormData().map((k, v) => MapEntry(k, v.toString())),
        )
        ..files.add(
          await http.MultipartFile.fromPath(
            "attachments",
            model.attachments.path,
            filename: model.attachments.path.split("/").last,
          ),
        );

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(responseBody.body);
        if (jsonBody["code"] == 200) {
          state = state.copyWith(
            loading: false,
            message: jsonBody["message"] ?? "Family Member added successfully",
          );
        } else {
          state = state.copyWith(
            loading: false,
            error: jsonBody["errors"]?.toString() ?? "Unknown error",
          );
        }
      } else {
        state = state.copyWith(
          loading: false,
          error: "Failed with status ${response.statusCode}",
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}