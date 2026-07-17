import 'package:equatable/equatable.dart';

abstract class FaceIdAuthState extends Equatable {
  const FaceIdAuthState();

  @override
  List<Object?> get props => [];
}

class FaceIdAuthInitial extends FaceIdAuthState {
  const FaceIdAuthInitial();
}

class FaceIdAuthLoading extends FaceIdAuthState {
  const FaceIdAuthLoading();
}

class FaceIdAuthSuccess extends FaceIdAuthState {
  final String message;

  const FaceIdAuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FaceIdAuthError extends FaceIdAuthState {
  final String message;

  const FaceIdAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class FaceIdAuthNotAvailable extends FaceIdAuthState {
  final String message;

  const FaceIdAuthNotAvailable(this.message);

  @override
  List<Object?> get props => [message];
}
