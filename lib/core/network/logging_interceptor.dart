import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../config/api_config.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    developer.log(
      'Request: ${options.method} ${_redact(options.uri)}',
      name: 'HTTP',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    developer.log(
      'Response: ${response.statusCode} ${_redact(response.requestOptions.uri)}',
      name: 'HTTP',
    );
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    developer.log(
      'Error: ${_redact(err.requestOptions.uri)}',
      name: 'HTTP',
      error: err,
    );
    handler.next(err);
  }

 
  String _redact(Uri uri) =>
      uri.toString().replaceAll(ApiConfig.apiKey, '***');
}
