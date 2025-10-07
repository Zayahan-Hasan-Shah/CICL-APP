import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../controllers/hospital_controller/hospital_controller.dart';
import '../../states/hospital_state/hospital_state.dart';

final hospitalProvider = StateNotifierProvider<HospitalController, HospitalState>(
  (ref) => HospitalController(),
);

final citiesProvider = Provider<List<String>>((ref) {
  return ref.read(hospitalProvider.notifier).getAllCities();
});