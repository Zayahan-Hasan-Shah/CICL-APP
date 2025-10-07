import 'package:flutter_riverpod/legacy.dart';

import '../../models/laboratory_model.dart';
import '../../states/laboratory_state/laboratory_state.dart';

class LaboratoryController extends StateNotifier<LaboratoryState> {
  LaboratoryController() : super(LaboratoryState());

  void fetchLaboratoriesByProvider(String providerName) {
    try {
      state = state.copyWith(isLoading: true, selectedProvider: providerName);

      final laboratories = LaboratoryRepository.getLaboratoriesForProvider(
        providerName,
      );

      state = state.copyWith(
        isLoading: false,
        laboratories: laboratories,
        error: laboratories.isEmpty
            ? 'No laboratories found for this provider'
            : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch laboratories: ${e.toString()}',
      );
    }
  }

  List<String> getAllLaboratoryProviders() {
    return LaboratoryRepository.getAllLaboratoryProviders();
  }

  void clearLaboratories() {
    state = state.copyWith(
      laboratories: [],
      selectedProvider: null,
      error: null,
    );
  }
}


