class AddClaimState {
  final bool loading;
  final String? error;
  final String? message;

  AddClaimState({
    this.loading = false,
    this.error,
    this.message,
  });

  AddClaimState copyWith({
    bool? loading,
    String? error,
    String? message,
  }) {
    return AddClaimState(
      loading: loading ?? this.loading,
      error: error,
      message: message,
    );
  }
}