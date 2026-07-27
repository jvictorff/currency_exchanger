import 'package:currency_exchanger/features/exchange/domain/entities/daily_rate.dart';
import 'package:currency_exchanger/features/exchange/domain/logic/close_diff.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: cria um dia só com data e fechamento.
DailyRate day(String isoDate, double close) => DailyRate(
  date: DateTime.parse(isoDate),
  open: 0,
  high: 0,
  low: 0,
  close: close,
);

void main() {
  group('computeCloseDiffs', () {
    test('retorna lista vazia para entrada vazia', () {
      expect(computeCloseDiffs(const []), isEmpty);
    });

    test('dia único tem closeDiff nulo (não há anterior)', () {
      final result = computeCloseDiffs([day('2026-07-01', 5.0)]);

      expect(result, hasLength(1));
      expect(result.single.closeDiff, isNull);
    });

    test('calcula a diferença e devolve do mais recente ao mais antigo', () {
      final input = [
        day('2026-07-01', 5.00),
        day('2026-07-02', 5.10),
        day('2026-07-03', 5.05),
      ];

      final result = computeCloseDiffs(input);

      // ordem de exibição: mais recente primeiro
      expect(result.map((e) => e.rate.date).toList(), [
        DateTime.parse('2026-07-03'),
        DateTime.parse('2026-07-02'),
        DateTime.parse('2026-07-01'),
      ]);

      // 03: 5.05 - 5.10 = -0.05 | 02: 5.10 - 5.00 = 0.10 | 01: sem anterior
      expect(result[0].closeDiff, closeTo(-0.05, 1e-9));
      expect(result[1].closeDiff, closeTo(0.10, 1e-9));
      expect(result[2].closeDiff, isNull);
    });

    test('ordena entradas fora de ordem antes de calcular', () {
      final input = [
        day('2026-07-03', 5.05),
        day('2026-07-01', 5.00),
        day('2026-07-02', 5.10),
      ];

      final result = computeCloseDiffs(input);

      final oldest = result.firstWhere(
        (e) => e.rate.date == DateTime.parse('2026-07-01'),
      );
      final middle = result.firstWhere(
        (e) => e.rate.date == DateTime.parse('2026-07-02'),
      );

      expect(oldest.closeDiff, isNull);
      expect(middle.closeDiff, closeTo(0.10, 1e-9));
    });

    test('não modifica a lista de entrada', () {
      final input = [day('2026-07-02', 5.10), day('2026-07-01', 5.00)];
      final snapshot = [...input];

      computeCloseDiffs(input);

      expect(input, snapshot); // mesma ordem, sem mutação
    });
  });
}
