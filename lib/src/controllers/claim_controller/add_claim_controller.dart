import 'dart:convert';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/services/logout_service.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/claim_model.dart/add_claim_model.dart';
import 'package:cicl_app/src/routing/app_router.dart';
import 'package:cicl_app/src/states/claim_state/add_claim_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

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
          final file = item.attachments[j].file;
          final size = await file.length();
          request.files.add(
            await http.MultipartFile.fromPath(
              "ClaimItems[$i][attachment][$j]",
              item.attachments[j].file.path,
            ),
          );
        }
      }

      request.fields.forEach((key, value) {
      });

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(responseBody.body);
        if (jsonBody["code"] == 200) {
          state = state.copyWith(
            loading: false,
            message: jsonBody["message"] ?? "Claim added successfully",
          );
        } else {
          final rawErrors = jsonBody["errors"];
          String errorMessage = "Unknown error";

          if (rawErrors is List && rawErrors.isNotEmpty) {
            errorMessage = rawErrors.join(", ");
          } else if (rawErrors is Map) {
            final parts = <String>[];
            rawErrors.forEach((key, value) {
              if (value is List) {
                parts.add("$key: ${value.join(', ')}");
              } else {
                parts.add("$key: $value");
              }
            });
            if (parts.isNotEmpty) {
              errorMessage = parts.join("\n");
            }
          } else if (rawErrors is String && rawErrors.isNotEmpty) {
            errorMessage = rawErrors;
          }

          state = state.copyWith(loading: false, error: errorMessage);
        }
      } else if (response.statusCode == 401) {
        final ctx = rootNavigatorKey.currentContext;
        if (ctx != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Your session has expired. Please login again.'),
            ),
          );
          await LogoutService(StorageService()).logout(ctx);
        } else {
          await StorageService().fullLogout();
        }
        state = state.copyWith(
          loading: false,
          error: 'Session expired. Please login again.',
        );
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
