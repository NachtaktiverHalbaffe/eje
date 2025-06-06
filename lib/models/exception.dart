class ServerException implements Exception {
  String? message;
  ExceptionType? type;

  ServerException({this.message, this.type});
}

class ConnectionException implements Exception {
  String? message;
  ExceptionType? type;

  ConnectionException({this.message, this.type});
}

class CacheException implements Exception {
  ExceptionType? type;
  String? message;

  CacheException({this.type, this.message});
}

enum ExceptionType { notFound, unknownError, badRequest, badResponse }
