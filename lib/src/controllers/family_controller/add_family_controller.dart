import 'dart:convert';
import 'dart:developer';

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

      final formFields = model.toFormData().map(
        (k, v) => MapEntry(k, v.toString()),
      );
      log('AddFamily endpoint: ${uri.toString()}');
      log('AddFamily request fields:');
      formFields.forEach((key, value) {
        log('  $key = $value');
      });

      final request = http.MultipartRequest("POST", uri)
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "User-Agent": "CICL-Mobile-App/1.0",
        })
        ..fields.addAll(formFields);

      for (int i = 0; i < model.attachments.length; i++) {
        final file = model.attachments[i];
        final fileName = file.path.split("/").last;
        log('AddFamily attachment_file[]: $fileName');
        request.files.add(
          await http.MultipartFile.fromPath(
            "attachment_file[]",
            file.path,
            filename: fileName,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      // Debug logs to inspect API behaviour
      log('AddFamily API status: ${response.statusCode}');
      log('AddFamily raw body: ${responseBody.body}');
      log('AddFamily raw body: ${responseBody.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(responseBody.body);
        log('AddFamily parsed jsonBody: $jsonBody');

        if (jsonBody["code"] == 200) {
          state = state.copyWith(
            loading: false,
            message: jsonBody["message"] ?? "Family Member added successfully",
          );
        } else {
          final rawErrors = jsonBody["errors"];
          log('AddFamily errors field: $rawErrors');
          String errorMessage = "Unknown error";

          if (rawErrors is List && rawErrors.isNotEmpty) {
            log('ERROR LIST: $rawErrors');
            errorMessage = rawErrors.join(", ");
          } else if (rawErrors is Map) {
            // Flatten map of field -> [messages]
            final parts = <String>[];
            rawErrors.forEach((key, value) {
              if (value is List) {
                parts.add("$key: ${value.join(', ')}");
              } else {
                parts.add("$key: $value");
              }
            });
            if (parts.isNotEmpty) {
              log("ERROR PARTS: $parts");
              errorMessage = parts.join("\n");
            }
          } else if (rawErrors is String && rawErrors.isNotEmpty) {
            errorMessage = rawErrors;
            log(" ERROR STRING: $errorMessage");
          }

          state = state.copyWith(
            loading: false,
            error: "Failed to add family member",
          );
        }
      } else {
        state = state.copyWith(
          loading: false,
          error: "Failed to add family member",
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
