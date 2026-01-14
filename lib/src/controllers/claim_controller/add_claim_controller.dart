import 'dart:convert';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/claim_model.dart/add_claim_model.dart';
import 'package:cicl_app/src/states/claim_state/add_claim_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class AddClaimController extends StateNotifier<AddClaimState> {
  AddClaimController() : super(AddClaimState());

  Future<void> addClaim(AddClaimModel model) async {
    try {
      state = state.copyWith(loading: true, error: null, message: null);

      final token = await StorageService().getAccessToken();
      final uri = Uri.parse(ApiUrl.addClaimUrl);

      final request = http.MultipartRequest("POST", uri)
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "User-Agent": "CICL-Mobile-App/1.0",
        });

      for (int i = 0; i < model.items.length; i++) {
        final item = model.items[i];
        final fields = item.toFormData(i);
        request.fields.addAll(fields);

        for (int j = 0; j < item.attachments.length; j++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "ClaimItems[$i][attachment][$j]",
              item.attachments[j].file.path,
            ),
          );
        }
      }

      log('AddClaim Request');
      log('API: $uri');
      log('Headers: ${request.headers}');
      log('Fields: ${jsonEncode(request.fields)}');

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      log("Response status: ${response.statusCode}");
      log("Response body: ${responseBody.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(responseBody.body);
        if (jsonBody["code"] == 200) {
          state = state.copyWith(
            loading: false,
            message: jsonBody["message"] ?? "Claim added successfully",
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