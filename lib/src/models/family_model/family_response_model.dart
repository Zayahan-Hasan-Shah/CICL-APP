import 'package:cicl_app/src/models/family_model/family_model.dart';

class FamilyResponseModel {
  final int? code;
  final List<FamilyModel>? data;
  final String? message;
  final String? errors;

  FamilyResponseModel(
      {required this.code,
      required this.data,
      required this.message,
      required this.errors});

  factory FamilyResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return FamilyResponseModel(
      code: json['code'] as int?,
      data: (data?['data'] as List<dynamic>?)
          ?.map((e) => FamilyModel.fromJson(e))
          .toList(),
      message: json['message'] as String?,
      errors: json['errors'] as String?,
    );
  }
}
