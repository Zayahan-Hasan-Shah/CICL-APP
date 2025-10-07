class AddFamilyState {
  final bool loading;
  final String? error;
  final String? message;

  AddFamilyState({
    this.loading = false,
    this.error,
    this.message,
  });

  AddFamilyState copyWith({
    bool? loading,
    String? error,
    String? message,
  }) {
    return AddFamilyState(
      loading: loading ?? this.loading,
      error: error,
      message: message,
    );
  }
}
