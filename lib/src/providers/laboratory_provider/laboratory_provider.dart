import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../controllers/laboratory_controller/laboratory_controller.dart';
import '../../states/laboratory_state/laboratory_state.dart';

final laboratoryProvider =
    StateNotifierProvider<LaboratoryController, LaboratoryState>(
      (ref) => LaboratoryController(),
    );

final laboratoryProvidersProvider = Provider<List<String>>((ref) {
  return ref.read(laboratoryProvider.notifier).getAllLaboratoryProviders();
});
