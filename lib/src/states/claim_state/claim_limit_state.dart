import 'package:cicl_app/src/models/claim_model.dart/claim_limit_model.dart';

class ClaimLimitState {
  final bool isLoading;
  final String? error;
  final UserClaimLimit? data;

  ClaimLimitState({this.isLoading = false, this.error, this.data});

  ClaimLimitState copyWith({
    bool? isLoading,
    String? error,
    UserClaimLimit? data,
  }) {
    return ClaimLimitState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}
