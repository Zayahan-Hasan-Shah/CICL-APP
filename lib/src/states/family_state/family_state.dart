import 'package:cicl_app/src/models/family_model/family_model.dart';

class FamilyState {
  final bool loading;
  final String? error;
  final List<FamilyModel> family;

  FamilyState({
    this.loading = false,
    this.error,
    this.family = const [],
  });

  FamilyState copyWith({
    bool? loading,
    String? error,
    List<FamilyModel>? family,
  }) {
    return FamilyState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      family: family ?? this.family,
    );
  }
}
