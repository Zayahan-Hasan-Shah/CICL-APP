import 'package:cicl_app/src/controllers/claim_controller/add_claim_controller.dart';
import 'package:cicl_app/src/states/claim_state/add_claim_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final addClaimProvider =
    StateNotifierProvider<AddClaimController, AddClaimState>(
  (ref) => AddClaimController(),
);
