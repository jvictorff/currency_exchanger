import 'package:bloc_test/bloc_test.dart';
import 'package:currency_exchanger/core/error/failure.dart';
import 'package:currency_exchanger/features/exchange/data/repositories/exchange_repository.dart';
import 'package:currency_exchanger/features/exchange/domain/entities/exchange_rate.dart';
import 'package:currency_exchanger/features/exchange/presentation/cubit/current_rate_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockExchangeRepository extends Mock implements ExchangeRepository {}

void main() {
  late MockExchangeRepository repository;
  late ExchangeRate rate;

  setUp(() {
    repository = MockExchangeRepository();
    rate = ExchangeRate(
      fromSymbol: 'USD',
      toSymbol: 'BRL',
      rate: 5.08,
      updatedAt: DateTime.parse('2026-07-23T03:00:00Z'),
    );
  });

  group('CurrentRateCubit', () {
    test('estado inicial é CurrentRateInitial', () {
      expect(CurrentRateCubit(repository).state, const CurrentRateInitial());
    });

    blocTest<CurrentRateCubit, CurrentRateState>(
      'emite [Loading, Loaded] quando o repositório retorna a taxa',
      build: () {
        when(
          () => repository.getCurrentRate('USD'),
        ).thenAnswer((_) async => rate);
        return CurrentRateCubit(repository);
      },
      act: (cubit) => cubit.load('USD'),
      expect: () => [const CurrentRateLoading(), CurrentRateLoaded(rate)],
    );

    blocTest<CurrentRateCubit, CurrentRateState>(
      'emite [Loading, Error] quando o repositório lança Failure',
      build: () {
        when(
          () => repository.getCurrentRate('USD'),
        ).thenThrow(const NetworkFailure());
        return CurrentRateCubit(repository);
      },
      act: (cubit) => cubit.load('USD'),
      expect: () => [
        const CurrentRateLoading(),
        const CurrentRateError(NetworkFailure()),
      ],
    );
  });
}
