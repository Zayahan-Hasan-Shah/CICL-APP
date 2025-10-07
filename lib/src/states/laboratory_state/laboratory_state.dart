import '../../models/laboratory_model/laboratory_model.dart';

class LaboratoryState {
  final bool isLoading;
  final String? selectedProvider;
  final List<Laboratory> laboratories;
  final String? error;

  LaboratoryState({
    this.isLoading = false,
    this.selectedProvider,
    this.laboratories = const [],
    this.error,
  });

  LaboratoryState copyWith({
    bool? isLoading,
    String? selectedProvider,
    List<Laboratory>? laboratories,
    String? error,
  }) {
    return LaboratoryState(
      isLoading: isLoading ?? this.isLoading,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      laboratories: laboratories ?? this.laboratories,
      error: error,
    );
  }
}


