// lib/src/models/service_model.dart

class ServiceResponse {
  final int code;
  final List<Service>? data;
  final String? message;
  final String? error;

  ServiceResponse({required this.code, this.data, this.message, this.error});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      code: json['code'] as int,
      data: json['data'] != null
          ? (json['data'] as Map<String, dynamic>).entries
                .map((entry) => Service.fromJson(entry.key, entry.value))
                .toList()
          : null,
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }
}

class Service {
  final String id; // e.g. "70001"
  final String name; // e.g. "HOSPITALIZATION"

  Service({required this.id, required this.name});

  factory Service.fromJson(String id, dynamic value) {
    return Service(id: id, name: value as String);
  }

  @override
  String toString() => 'Service(id: $id, name: $name)';
}
