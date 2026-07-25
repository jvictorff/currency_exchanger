import 'package:dio/dio.dart';

import '../config/api_config.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.queryParameters['apiKey'] = ApiConfig.apiKey;
    handler.next(options);
  }
}
