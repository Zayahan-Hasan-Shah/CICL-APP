import 'package:cicl_app/src/controllers/family_controller/family_controller.dart';
import 'package:cicl_app/src/states/family_state/family_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final familyMemberControllerProvider =
    StateNotifierProvider<FamilyController, FamilyState>((ref) {
      return FamilyController();
    });
