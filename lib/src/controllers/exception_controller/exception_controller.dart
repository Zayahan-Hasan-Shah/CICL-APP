class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => "NetworkException: $message";
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);

  @override
  String toString() => "UnexpectedException: $message";
}