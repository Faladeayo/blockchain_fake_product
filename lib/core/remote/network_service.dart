import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../provider/base_url_provider.dart';
import 'network_service_interceptor.dart';

/// Provide the instance of Dio
final networkServiceProvider = Provider.autoDispose<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);

  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 45),
    receiveTimeout: const Duration(seconds: 30),
  );

  // Add our custom interceptors
  final dio = Dio(options)
    ..interceptors.addAll([
      // HttpFormatter(),
      NetworkServiceInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
    ]);

  return dio;
});
