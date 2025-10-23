import 'package:equatable/equatable.dart';

abstract class FingerprintAuthState extends Equatable {
  const FingerprintAuthState();

  @override
  List<Object?> get props => [];
}

class FingerprintAuthInitial extends FingerprintAuthState {
  const FingerprintAuthInitial();
}

class FingerprintAuthLoading extends FingerprintAuthState {
  const FingerprintAuthLoading();
}

class FingerprintAuthSuccess extends FingerprintAuthState {
  final String message;

  const FingerprintAuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FingerprintAuthError extends FingerprintAuthState {
  final String message;

  const FingerprintAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class FingerprintAuthNotAvailable extends FingerprintAuthState {
  final String message;

  const FingerprintAuthNotAvailable(this.message);

  @override
  List<Object?> get props => [message];
}
