import 'package:cicl_app/src/controllers/family_controller/add_family_controller.dart';
import 'package:cicl_app/src/states/family_state/add_family_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final addFamilyProvider =
    StateNotifierProvider<AddFamilyController, AddFamilyState>(
  (ref) => AddFamilyController(),
);