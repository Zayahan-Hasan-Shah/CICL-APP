import 'package:cicl_app/src/controllers/auth_controller/face_id_auth_controller.dart';
import 'package:cicl_app/src/states/auth_state/face_id_auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final faceIdAuthProvider =
    StateNotifierProvider<FaceIdAuthController, FaceIdAuthState>(
      (ref) => FaceIdAuthController(),
    );
