import 'package:bloc_test/bloc_test.dart';
import 'package:currency_exchanger/core/error/failure.dart';
import 'package:currency_exchanger/features/exchange/data/repositories/exchange_repository.dart';
import 'package:currency_exchanger/features/exchange/domain/entities/daily_rate.dart';
import 'package:currency_exchanger/features/exchange/domain/logic/close_diff.dart';
import 'package:currency_exchanger/features/exchange/presentation/cubit/history_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExchangeRepository extends Mock implements ExchangeRepository {}

DailyRate day(String isoDate, double close) => DailyRate(
  date: DateTime.parse(isoDate),
  open: 0,
  high: 0,
  low: 0,
  close: close,
);

void main() {
  late MockExchangeRepository repository;
  late List<DailyRate> rates;

  setUp(() {
    repository = MockExchangeRepository();
    rates = [day('2026-07-01', 5.00), day('2026-07-02', 5.10)];
  });

  group('HistoryCubit', () {
    test('estado inicial é HistoryInitial', () {
      expect(HistoryCubit(repository).state, const HistoryInitial());
    });

    blocTest<HistoryCubit, HistoryState>(
      'emite [Loading, Loaded] com os dias já com close diff calculado',
      build: () {
        when(
          () => repository.getDailyRates('USD'),
        ).thenAnswer((_) async => rates);
        return HistoryCubit(repository);
      },
      act: (cubit) => cubit.load('USD'),
      expect: () => [
        const HistoryLoading(),
        HistoryLoaded(computeCloseDiffs(rates)),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'emite [Loading, Error] quando o repositório lança Failure',
      build: () {
        when(
          () => repository.getDailyRates('USD'),
        ).thenThrow(const RateLimitFailure());
        return HistoryCubit(repository);
      },
      act: (cubit) => cubit.load('USD'),
      expect: () => [
        const HistoryLoading(),
        const HistoryError(RateLimitFailure()),
      ],
    );
  });
}
