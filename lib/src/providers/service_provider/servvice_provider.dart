import 'package:cicl_app/src/controllers/service_controller/service_controller.dart';
import 'package:cicl_app/src/states/service_state/service_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final serviceControllerProvider =
    StateNotifierProvider<ServiceController, ServiceState>(
      (ref) => ServiceController(),
    );
