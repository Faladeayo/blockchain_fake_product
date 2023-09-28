class Failure {
  final String message;
  final int? statusCode;
  final StackTrace stackTrace;
  Failure({
    required this.message,
    required this.stackTrace,
    this.statusCode,
  });
}
