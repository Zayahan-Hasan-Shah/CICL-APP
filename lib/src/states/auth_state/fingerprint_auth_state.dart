abstract class FingerprintAuthState {}

class FingerprintAuthInitial extends FingerprintAuthState {}

class FingerprintAuthLoading extends FingerprintAuthState {}

class FingerprintAuthSuccess extends FingerprintAuthState {
  final String message;
  FingerprintAuthSuccess(this.message);
}

class FingerprintAuthError extends FingerprintAuthState {
  final String message;
  FingerprintAuthError(this.message);
}

class FingerprintAuthNotAvailable extends FingerprintAuthState {
  final String message;
  FingerprintAuthNotAvailable(this.message);
}
