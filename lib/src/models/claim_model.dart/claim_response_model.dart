import 'package:cicl_app/src/models/claim_model.dart/claim_model.dart';

class ClaimResponse {
  final int? code;
  final int? page;
  final int? pageSize;
  final int? total;
  final List<Claim>? result;

  ClaimResponse({
    this.code,
    this.page,
    this.pageSize,
    this.total,
    this.result,
  });

  factory ClaimResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return ClaimResponse(
      code: json['code'] as int?,
      page: data?['page'] as int?,
      pageSize: data?['pageSize'] as int?,
      total: data?['total'] as int?,
      result: (data?['result'] as List<dynamic>?)
          ?.map((e) => Claim.fromJson(e))
          .toList(),
    );
  }
}