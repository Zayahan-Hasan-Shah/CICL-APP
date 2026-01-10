import 'package:cicl_app/src/models/service_model/service_model.dart';

class ServiceState {
  final bool loading;
  final String? error;
  final List<Service>? services;

  ServiceState({this.loading = false, this.error, this.services});

  ServiceState copyWith({
    bool? loading,
    String? error,
    List<Service>? services,
  }) {
    return ServiceState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      services: services ?? this.services,
    );
  }
}
