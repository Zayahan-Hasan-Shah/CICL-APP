import 'package:flutter_riverpod/legacy.dart';

import '../../models/hospital_model.dart';
import '../../states/hospital_state/hospital_state.dart';

class HospitalController extends StateNotifier<HospitalState> {
  HospitalController() : super(HospitalState());

  void fetchHospitalsByCity(String cityName) {
    state = state.copyWith(isLoading: true, selectedCity: cityName);

    final hospitals = PanelHospitalRepository.getHospitalsForCity(cityName);

    state = state.copyWith(
      isLoading: false,
      hospitals: hospitals,
      error: hospitals.isEmpty ? 'No hospitals found for this city' : null,
    );
  }

  List<String> getAllCities() {
    return PanelHospitalRepository.getAllCities();
  }

  void clearHospitals() {
    state = state.copyWith(hospitals: [], selectedCity: null, error: null);
  }
}
