import '../../models/hospital_model.dart';

class HospitalState {
  final bool isLoading;
  final String? selectedCity;
  final List<PanelHospital> hospitals;
  final String? error;

  HospitalState({
    this.isLoading = false,
    this.selectedCity,
    this.hospitals = const [],
    this.error,
  });

  HospitalState copyWith({
    bool? isLoading,
    String? selectedCity,
    List<PanelHospital>? hospitals,
    String? error,
  }) {
    return HospitalState(
      isLoading: isLoading ?? this.isLoading,
      selectedCity: selectedCity ?? this.selectedCity,
      hospitals: hospitals ?? this.hospitals,
      error: error,
    );
  }
}

