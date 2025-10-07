import 'package:cicl_app/src/models/profile_model/card_detail_model.dart';

class CardDetailsState {
  final bool isLoading;
  final CardDetailsData? data;
  final String? error;

  const CardDetailsState({this.isLoading = false, this.data, this.error});

  CardDetailsState copyWith({
    bool? isLoading,
    CardDetailsData? data,
    String? error,
  }) {
    return CardDetailsState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}
