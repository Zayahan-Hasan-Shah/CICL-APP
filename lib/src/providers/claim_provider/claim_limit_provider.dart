import 'package:cicl_app/src/controllers/claim_controller/claim_limit_controller.dart';
import 'package:cicl_app/src/states/claim_state/claim_limit_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final claimLimitProvider =
    StateNotifierProvider<ClaimLimitController, ClaimLimitState>(
  (ref) => ClaimLimitController(),
);