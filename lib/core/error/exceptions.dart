class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ClientException implements Exception {
  final String message;
  ClientException(this.message);
  @override
  String toString() => 'ClientException: $message';
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  @override
  String toString() => 'ServerException: $message';
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);
  @override
  String toString() => 'UnexpectedException: $message';
}
