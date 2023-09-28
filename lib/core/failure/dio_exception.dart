import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(
    DioException dioError,
  ) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Error Connection Timeout";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Error Receive Timeout";
        break;
      case DioExceptionType.badResponse:
        message =
            _handleError(dioError.response?.statusCode, dioError.response)!;
        break;
      case DioExceptionType.sendTimeout:
        message = "Error Send Timeout";
        break;
      case DioExceptionType.unknown:
        if (dioError.message!.contains("SocketException")) {
          message =
              'No Internet!!! Ensure You Have An Active Internet Connection';
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Error Internet Connection";
        break;
    }
  }

  String? _handleError(int? statusCode, Response? error) {
    switch (statusCode) {
      case 400:
        String? emailError =
            error?.data['email'] != null ? error?.data['email'][0] : null;
        String? passwordError =
            error?.data['password'] != null ? error?.data['password'][0] : null;
        return emailError ?? passwordError ?? error?.statusMessage;
      case 401:
        String? unauthorized = error?.data['detail'];
        return unauthorized ?? 'Unauthorized';
      case 403:
        return error?.statusMessage;
      case 404:
        return 'Not Found';
      case 422:
        String? emailError = error?.data['email'];
        return emailError ?? error?.data.toString();
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return error?.statusMessage;
    }
  }

  @override
  String toString() => message;
}
