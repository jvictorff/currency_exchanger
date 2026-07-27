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

    test('dia único não tem diferença (absoluta nem percentual)', () {
      final result = computeCloseDiffs([day('2026-07-01', 5.0)]);

      expect(result, hasLength(1));
      expect(result.single.closeDiff, isNull);
      expect(result.single.closeDiffPercent, isNull);
    });

    test('calcula absoluto e percentual, do mais recente ao mais antigo', () {
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

      // 03: close 5.05 vs 5.10 => -0.05 abs | -0.9804% percentual
      expect(result[0].closeDiff, closeTo(-0.05, 1e-9));
      expect(result[0].closeDiffPercent, closeTo(-0.980392, 1e-6));

      // 02: close 5.10 vs 5.00 => +0.10 abs | +2.0% percentual
      expect(result[1].closeDiff, closeTo(0.10, 1e-9));
      expect(result[1].closeDiffPercent, closeTo(2.0, 1e-9));

      // 01: sem anterior
      expect(result[2].closeDiff, isNull);
      expect(result[2].closeDiffPercent, isNull);
    });

    test('percentual é null quando o fechamento anterior é zero', () {
      final input = [day('2026-07-01', 0.0), day('2026-07-02', 5.0)];

      final result = computeCloseDiffs(input);
      final second = result.firstWhere(
        (e) => e.rate.date == DateTime.parse('2026-07-02'),
      );

      expect(second.closeDiff, closeTo(5.0, 1e-9)); // absoluto ainda existe
      expect(second.closeDiffPercent, isNull); // percentual não (evita ÷0)
    });

    test('limit devolve só os N mais recentes, com diff correto no corte', () {
      final input = [
        day('2026-07-01', 5.00),
        day('2026-07-02', 5.10),
        day('2026-07-03', 5.05),
      ];

      final result = computeCloseDiffs(input, limit: 2);

      expect(result, hasLength(2));
      expect(result[0].rate.date, DateTime.parse('2026-07-03'));
      expect(result[1].rate.date, DateTime.parse('2026-07-02'));
      // o diff do 02 usa o fechamento do 01, que foi calculado antes do corte
      expect(result[1].closeDiff, closeTo(0.10, 1e-9));
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
