import 'dart:convert';
import 'dart:developer';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/claim_model.dart/add_claim_model.dart';
import 'package:cicl_app/src/states/claim_state/add_claim_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class AddClaimController extends StateNotifier<AddClaimState> {
  AddClaimController() : super(AddClaimState());

  Future<void> addClaim(AddClaimModel model) async {
    try {
      state = state.copyWith(loading: true, error: null, message: null);

      final token = await StorageService().getAccessToken();
      log("AddClaimController → Using access token: $token");

      final uri = Uri.parse(ApiUrl.addClaimUrl);

      // Build request
      final request = http.MultipartRequest("POST", uri)
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        });

      // Add all claim fields
      for (int i = 0; i < model.items.length; i++) {
        final item = model.items[i];
        final fields = item.toFormData(i);

        request.fields.addAll(fields);
        log("AddClaimController → ClaimItem[$i] fields: $fields");

        // If you later need file uploads:
        for (int j = 0; j < item.attachments.length; j++) {
          log("ClaimItems[$i][attachment][$j]");
          request.files.add(
            await http.MultipartFile.fromPath(
              "ClaimItems[$i][attachment][$j]",
              item.attachments[j].file.path,
            ),
          );
        }
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("AddClaimController → Status: ${response.statusCode}");
      log("AddClaimController → Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

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
    } catch (e, st) {
      log("AddClaimController → Error: $e\n$st");
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
