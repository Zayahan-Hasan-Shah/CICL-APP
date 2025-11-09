import 'package:cicl_app/src/controllers/bmi_controller/bmi_controller.dart';
import 'package:cicl_app/src/states/bmi_state/bmi_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final bmiProvider = StateNotifierProvider<BmiController, BmiState>(
  (ref) => BmiController(),
);
