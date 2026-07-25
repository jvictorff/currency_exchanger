import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

Dio buildDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(AuthInterceptor());

  if (kDebugMode) {
    dio.interceptors.add(LoggingInterceptor());
  }

  return dio;
}
