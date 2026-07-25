import '../../domain/entities/daily_rate.dart';
import '../../domain/entities/exchange_rate.dart';
import '../datasources/exchange_remote_data_source.dart';

class ExchangeRepository {
  const ExchangeRepository(this._remote);

  final ExchangeRemoteDataSource _remote;

  Future<ExchangeRate> getCurrentRate(String currency) async {
    final dto = await _remote.getCurrentRate(currency);
    return dto.toEntity();
  }

  Future<List<DailyRate>> getDailyRates(String currency) async {
    final dtos = await _remote.getDailyRates(currency);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
