import 'package:currency_exchanger/core/error/failure.dart';
import 'package:currency_exchanger/features/exchange/data/repositories/exchange_repository.dart';
import 'package:currency_exchanger/features/exchange/domain/entities/exchange_rate.dart';
import 'package:currency_exchanger/features/exchange/presentation/cubit/current_rate_cubit.dart';
import 'package:currency_exchanger/features/exchange/presentation/cubit/history_cubit.dart';
import 'package:currency_exchanger/features/exchange/presentation/pages/exchange_page.dart';
import 'package:currency_exchanger/features/exchange/presentation/widgets/current_rate_card.dart';
import 'package:currency_exchanger/features/exchange/presentation/widgets/failure_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExchangeRepository extends Mock implements ExchangeRepository {}

void main() {
  late MockExchangeRepository repository;

  setUp(() => repository = MockExchangeRepository());

  // Monta a ExchangeView com Cubits reais + repositório mockado (sem get_it).
  Widget wrap() => MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CurrentRateCubit(repository)),
        BlocProvider(create: (_) => HistoryCubit(repository)),
      ],
      child: const ExchangeView(),
    ),
  );

  testWidgets('exibe a taxa atual ao buscar uma moeda válida', (tester) async {
    final rate = ExchangeRate(
      fromSymbol: 'USD',
      toSymbol: 'BRL',
      rate: 5.08,
      updatedAt: DateTime.parse('2026-07-23T03:00:00Z'),
    );
    when(() => repository.getCurrentRate('USD')).thenAnswer((_) async => rate);

    await tester.pumpWidget(wrap());
    await tester.enterText(find.byType(TextField), 'USD');
    await tester.tap(find.text('EXCHANGE RESULT'));
    await tester.pumpAndSettle();

    expect(find.byType(CurrentRateCard), findsOneWidget);
    expect(find.text('USD/BRL'), findsOneWidget);
  });

  testWidgets('exibe mensagem de erro quando a busca falha', (tester) async {
    when(
      () => repository.getCurrentRate('EUR'),
    ).thenThrow(const NetworkFailure());

    await tester.pumpWidget(wrap());
    await tester.enterText(find.byType(TextField), 'EUR');
    await tester.tap(find.text('EXCHANGE RESULT'));
    await tester.pumpAndSettle();

    expect(find.byType(FailureView), findsOneWidget);
    expect(find.textContaining('Sem conexão'), findsOneWidget);
  });

  testWidgets('não busca com código de menos de 3 letras', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.enterText(find.byType(TextField), 'US');
    await tester.tap(find.text('EXCHANGE RESULT'));
    await tester.pump();

    verifyNever(() => repository.getCurrentRate(any()));
    expect(find.byType(CurrentRateCard), findsNothing);
  });
}
