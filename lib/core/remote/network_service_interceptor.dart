import 'package:dio/dio.dart';

import '../services/auth_service.dart';

/// NetworkServiceInterceptor will override the onRequest method from  Dio Interceptor class
/// onRequest method will add out custom headers

class NetworkServiceInterceptor extends Interceptor {
  NetworkServiceInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Read the access token form the secure storage
    String accessToken = AuthService.instance.authUser?.token ?? "";

    // ignore: unnecessary_null_comparison
    if (AuthService.instance.authUser != null) {
      options.headers['Accept'] = 'application/json';
      options.headers['contentType'] = 'application/json';
      options.headers['x-auth-token'] = ' $accessToken';
    } else {
      options.headers['Accept'] = 'application/json';
      options.headers['contentType'] = 'application/json';
    }

    super.onRequest(options, handler);
  }
}
