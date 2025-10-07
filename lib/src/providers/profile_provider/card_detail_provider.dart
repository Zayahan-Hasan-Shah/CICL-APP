import 'package:cicl_app/src/controllers/profile_controller/card_detail_controller.dart';
import 'package:cicl_app/src/states/profile_state/card_detail_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final cardDetailsProvider =
    StateNotifierProvider<CardDetailsController, CardDetailsState>(
  (ref) => CardDetailsController(),
);