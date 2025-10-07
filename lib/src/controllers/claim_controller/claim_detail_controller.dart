import 'dart:convert';
import 'dart:developer';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/claim_model.dart/claim_detail_model.dart'
    show ClaimDetailResponse;
import 'package:cicl_app/src/states/claim_state/claim_detail_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

class ClaimDetailController extends StateNotifier<ClaimDetailState> {
  ClaimDetailController() : super(ClaimDetailInitial());

  Future<void> fetchClaimDetail(String clmseqnos) async {
    state = ClaimDetailLoading();

    try {
      log("CLMSEQNOS : $clmseqnos");
      log("*** API URL : ${ApiUrl.getClaimDetailUrl} ***");
      final token = await StorageService().getAccessToken();
      final response = await http.post(
        Uri.parse(ApiUrl.getClaimDetailUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode({"clmseqnos": clmseqnos}),
      );

      log("ClaimDetailController → Response status: ${response.statusCode}");
      log("ClaimDetailController → Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final claimDetail = ClaimDetailResponse.fromJson(jsonData);
        state = ClaimDetailLoaded(claimDetail);
      } else {
        state = ClaimDetailError("Failed: ${response.body}");
      }
    } catch (e, st) {
      log("ClaimController → Error: $e\n$st");
      state = ClaimDetailError(e.toString());
    }
  }
}
