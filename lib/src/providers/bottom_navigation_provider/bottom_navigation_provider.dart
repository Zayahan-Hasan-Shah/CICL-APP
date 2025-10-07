import 'package:cicl_app/src/controllers/bottom_navigation_controller/bottom_navigation_controller.dart';
import 'package:flutter_riverpod/legacy.dart';

final bottomNavigationProvider =
    StateNotifierProvider<BottomNavigationController, int>((ref) {
  return BottomNavigationController();
});
