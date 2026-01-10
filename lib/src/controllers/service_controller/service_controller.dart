import 'dart:convert';

import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/service_model/service_model.dart';
import 'package:cicl_app/src/states/service_state/service_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class ServiceController extends StateNotifier<ServiceState> {
  ServiceController() : super(ServiceState());

  Future<void> fetchService() async {
    try {
      state = state.copyWith(loading: true, error: null);
      final token = await StorageService().getAccessToken();
      final uri = Uri.parse(ApiUrl.getServicesUrl);

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body) as Map<String, dynamic>;
        final serviceResponse = ServiceResponse.fromJson(jsonBody);

        state = state.copyWith(
          loading: false,
          services: serviceResponse.data,
          error: null,
        );
      } else {
        // Handle non-200 responses
        state = state.copyWith(
          loading: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
