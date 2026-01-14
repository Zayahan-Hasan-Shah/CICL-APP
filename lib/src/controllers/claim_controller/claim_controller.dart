import 'dart:convert';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/models/claim_model.dart/claim_model.dart';
import 'package:cicl_app/src/states/claim_state/claim_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class ClaimController extends StateNotifier<ClaimState> {
  ClaimController() : super(ClaimState());

  Future<void> fetchClaims({
    int page = 0,
    int pageSize = 10,
    String? startDate = "2024-06-01",
    String? endDate = "2025-08-30",
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);

      final token = await StorageService().getAccessToken();
      final url = Uri.parse(ApiUrl.getClaimUrl);

      final bodySent = {
        "startDate": startDate,
        "endDate": AppValidation().getCurrentDate(),
        "page": page,
        "pageSize": pageSize,
      };

      final response = await http.post(
        url,
        body: jsonEncode(bodySent),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "User-Agent": "CICL-Mobile-App/1.0",
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody["data"];

        final total = data["total"] ?? 0;
        final List<dynamic> result = data["result"] ?? [];

        final claims = result.map((e) => Claim.fromJson(e)).toList();
        final claimSeqNos = claims.map((e) => e.clmseqnos.toString()).toList();
        await StorageService().saveClaimSeqNos(claimSeqNos);

        state = state.copyWith(
          loading: false,
          error: null,
          claims: claims,
          total: total,
        );
      } else {
        state = state.copyWith(
          loading: false,
          error: "Failed to fetch claims.",
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}