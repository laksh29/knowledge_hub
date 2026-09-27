class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;
}

class CacheException implements Exception {
  const CacheException([this.message]);
  final String? message;
}

class DuplicateNameException implements Exception {
  const DuplicateNameException([this.message]);
  final String? message;
}
