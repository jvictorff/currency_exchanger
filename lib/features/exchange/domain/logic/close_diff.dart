import '../entities/daily_rate.dart';
import '../entities/daily_rate_with_diff.dart';

/// Calcula o `close diff` de cada dia: a variação do fechamento em relação ao
/// dia anterior, tanto em valor absoluto quanto em percentual.
///
/// Regras:
/// - ordena por data (ascendente) antes de calcular — não confia na ordem da API;
/// - o dia mais antigo fica com as diferenças `null` (não há anterior);
/// - percentual = null quando o fechamento anterior é 0 (evita divisão por zero);
/// - a lista de entrada NÃO é modificada (trabalha sobre uma cópia);
/// - devolve do mais recente para o mais antigo (ordem de exibição);
/// - [limit]: se informado, devolve só os N mais recentes. O corte é feito
///   APÓS o cálculo, então o diff do dia-limite ainda usa o dia anterior real.
List<DailyRateWithDiff> computeCloseDiffs(List<DailyRate> rates, {int? limit}) {
  if (rates.isEmpty) return const [];

  final ascending = [...rates]..sort((a, b) => a.date.compareTo(b.date));

  final withDiff = <DailyRateWithDiff>[];
  for (var i = 0; i < ascending.length; i++) {
    if (i == 0) {
      withDiff.add(DailyRateWithDiff(rate: ascending[i]));
      continue;
    }

    final previousClose = ascending[i - 1].close;
    final diff = ascending[i].close - previousClose;
    final percent = previousClose == 0 ? null : diff / previousClose * 100;

    withDiff.add(
      DailyRateWithDiff(
        rate: ascending[i],
        closeDiff: diff,
        closeDiffPercent: percent,
      ),
    );
  }

  final descending = withDiff.reversed.toList();
  if (limit == null || limit >= descending.length) return descending;
  return descending.take(limit).toList();
}
