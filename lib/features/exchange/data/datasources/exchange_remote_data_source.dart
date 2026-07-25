import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/error/failure.dart';
import '../dtos/current_rate_dto.dart';
import '../dtos/daily_rate_dto.dart';

class ExchangeRemoteDataSource {
  const ExchangeRemoteDataSource(this._dio);

  final Dio _dio;

  Future<CurrentRateDto> getCurrentRate(String fromSymbol) {
    return _guard(() async {
      final json = await _request(ApiConfig.currentRatePath, fromSymbol);
      return CurrentRateDto.fromJson(json);
    });
  }

  Future<List<DailyRateDto>> getDailyRates(String fromSymbol) {
    return _guard(() async {
      final json = await _request(ApiConfig.dailyRatePath, fromSymbol);
      final data = json['data'] as List<dynamic>;
      return data
          .map((e) => DailyRateDto.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Map<String, dynamic>> _request(String path, String fromSymbol) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: {
        'from_symbol': fromSymbol,
        'to_symbol': ApiConfig.baseCurrency,
      },
    );

    final json = response.data as Map<String, dynamic>;
    
    if (json['rateLimitExceeded'] == true) {
      throw const RateLimitFailure();
    }
    if (json['success'] != true) {
      throw const CurrencyNotFoundFailure();
    }

    return json;
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on Failure {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on Object catch (_) {
      throw const ServerFailure();
    }
  }

  Failure _mapDioException(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse
        when (e.response?.statusCode ?? 0) == 404 =>
      const CurrencyNotFoundFailure(),
    _ => const ServerFailure(),
  };
}
