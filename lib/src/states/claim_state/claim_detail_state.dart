import 'package:cicl_app/src/models/claim_model.dart/claim_detail_model.dart';

sealed class ClaimDetailState {}

class ClaimDetailInitial extends ClaimDetailState {}

class ClaimDetailLoading extends ClaimDetailState {}

class ClaimDetailLoaded extends ClaimDetailState {
  final ClaimDetailResponse claimDetail;
  ClaimDetailLoaded(this.claimDetail);
}

class ClaimDetailError extends ClaimDetailState {
  final String message;
  ClaimDetailError(this.message);
}
