import 'package:cicl_app/src/models/claim_model.dart/claim_model.dart';

class ClaimState {
  final bool loading;
  final String? error;
  final List<Claim> claims;
  final int total;

  ClaimState({
    this.loading = false,
    this.error,
    this.claims = const [],
    this.total = 0,
  });

  ClaimState copyWith({
    bool? loading,
    String? error,
    List<Claim>? claims,
    int? total,
  }) {
    return ClaimState(
      loading: loading ?? this.loading,
      error: error,
      claims: claims ?? this.claims,
      total: total ?? this.total,
    );
  }
}
