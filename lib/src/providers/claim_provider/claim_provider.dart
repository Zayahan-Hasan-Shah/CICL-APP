import 'package:cicl_app/src/controllers/claim_controller/claim_controller.dart';
import 'package:cicl_app/src/states/claim_state/claim_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final claimControllerProvider =
    StateNotifierProvider<ClaimController, ClaimState>((ref) {
  return ClaimController();
});