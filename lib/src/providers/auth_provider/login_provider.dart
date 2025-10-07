import 'package:cicl_app/src/controllers/auth_controller/login_controller.dart';
import 'package:cicl_app/src/states/auth_state/login_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);
