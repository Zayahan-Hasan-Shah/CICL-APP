import 'package:cicl_app/src/controllers/claim_controller/claim_detail_controller.dart';
import 'package:cicl_app/src/states/claim_state/claim_detail_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final claimProvider =
    StateNotifierProvider<ClaimDetailController, ClaimDetailState>((ref) {
      return ClaimDetailController();
    });
