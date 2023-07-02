class HttpException implements Exception {
  String message;

  HttpException(this.message);

  // ignore: unnecessary_overrides
  @override
  String toString() {
    return message;
  }
}
